import re
import json
from typing import Optional

from bs4 import Tag
from dataclasses import dataclass

from utils import sections_by_tag, tags_to_desc, desc_to_comment, parse_table, js_type_code_to_json

DESC_FIELDS_REGEX = {
	"IS_FIELDS": re.compile(r"with the following properties"),
}

RETURN_VALUE_REGEX = {
	re.compile(r"following (?:error )?codes"): lambda tags, ri, match: "|".join([field["constant"].text for field in parse_table(tags[ri+1])]),
	re.compile(r"The name of"): lambda tags, ri, match: "string",
	re.compile(r"[Aa]n array of (\w+) objects"): lambda tags, ri, match: f"{match.group(1)}[]",
	re.compile(r"[Aa]n array (?:of|with the) objects"): lambda tags, ri, match: "RoomObject[]",
}


TYPE_JS_TO_LUA = {
	"object": "table",
	"array": "any[]",
	"null": "nil"
}

CPU_CLASS_DESC = {
	"0": "Insignificant CPU cost",
	"1": "Low CPU cost.",
	"2": "Medium CPU cost.",
	"3": "High CPU cost.",
	"A": "Additional 0.2 CPU if OK is returned.",
}


def parse_js_type(type_: str):
	parts = type_.replace(" ", "").rstrip(">").split("<", 1)
	if len(parts) > 1:
		return parts[0], parts[1].split(",")
	else:
		return parts[0], []


def to_lua_type(type_: str):
	parts = re.split(r"\||,(?![\w\s]+>)", type_)
	new_parts = []
	for part in parts:
		part = part.split("(")[0].strip()
		if "<" in part:
			type_, type_opts = parse_js_type(part)
			type_args = ",".join([to_lua_type(opt) for opt in type_opts])
			if type_ == "array":
				new_parts.append(f"({type_args})[]")
			else:
				new_parts.append(f"{TYPE_JS_TO_LUA.get(type_, type_)}<{type_args}>")
		else:
			new_parts.append(TYPE_JS_TO_LUA.get(part, part))
	return "|".join(new_parts)


PY_TO_LUA_TYPE = {
	"str": "string",
	"int": "integer",
	"float": "number",
	"dict": "table",
	"list": "any[]"
}


def py_to_lua_type(value: any):
	return PY_TO_LUA_TYPE.get(type(value).__name__, type(value).__name__)


def dict_consistent_values(base: dict, other: dict):
	found_inconsistency = False
	for key, value in {**base, **other}.items():
		if key in base and key not in other:
			del base[key]
			found_inconsistency = True
	return found_inconsistency


def json_to_type(data: any):
	def _key_type(_key: str):
		if _key.isdecimal():
			return int(_key)
		elif _key.isdecimal():
			return float(_key)
		return _key

	if type(data) == list:
		if len(data) > 0:
			value = data[0]
			if type(value) == dict:
				found_inconsistency = False
				for other in data[1:]:
					found_inconsistency = dict_consistent_values(value, other) or found_inconsistency
				if found_inconsistency:
					return f"({json_to_type(value)}|table)[]"
			return f"{json_to_type(value)}[]"
	elif type(data) == dict:
		if len(data) > 0:
			fields = {}
			for key, value in data.items():
				if key[0].isdigit():
					break
				fields[key] = json_to_type(value)
			else:
				fields_final = []
				for key, type_ in fields.items():
					fields_final.append(f"{key}:{type_}")
				return f"{{{','.join(fields_final)}}}"
			key = next(iter(data.keys()))
			value = next(iter(data.values()))
			return f"table<{json_to_type(_key_type(key))},{json_to_type(value)}>"
	return py_to_lua_type(data)


class JSMethod:
	@dataclass()
	class JSArg:
		name: str
		optional: bool = False

	@dataclass()
	class ArgInfo:
		name: str
		type: str
		desc: str

	description: str
	deprecated: bool
	cpu_class: Optional[str]
	overloads: list[list[JSArg]]
	returns: list[str]
	args_info: dict[str, ArgInfo]

	# Tag index to start and end at
	tag_start: int
	tag_end: int

	def __init__(self, name: str):
		self.name = name

	def parse_return_tags(self, tags: list[Tag]):
		self.returns = []
		for i in range(self.tag_end, self.tag_start, -1):
			if tags[i].name == "h3" and tags[i].text == "Return value":
				for ri in range(i+1, self.tag_end+1):
					tag = tags[ri]
					tag_text = tag.text
					if tag.name == "pre":
						json_str = js_type_code_to_json(tag_text)
						try:
							self.returns.append(json_to_type(json.loads(json_str)))
						except json.decoder.JSONDecodeError:
							# print("Failed to parse as json")
							# print("- RAW -")
							# print(tag.text)
							# print("- CLEANED -")
							# print(json_str)
							pass
					else:
						for reg, f in RETURN_VALUE_REGEX.items():
							if match := reg.search(tag_text):
								self.returns.append(f(tags, ri, match))
				self.tag_end = i-1
				break

	def parse_arg_info_tags(self, tags: list[Tag]):
		self.args_info = {}
		for i in range(self.tag_end, self.tag_start, -1):
			# noinspection PyUnboundLocalVariable
			if tags[i].name == "table" and (table := parse_table(tags[i])) and len(table) > 0:
				if all(k in table[0] for k in ("parameter", "type", "description")):
					self.tag_end = i-1
					for field in table:
						name, type_, desc = field["parameter"].text, field["type"].text, field["description"]
						self.args_info[name] = JSMethod.ArgInfo(name, type_, desc.text)
					break

	def parse_tags(self, tags: list[Tag]):
		self.deprecated = "api-property--deprecated" in tags[0]["class"]
		if cpu_tag := tags[0].find(class_="api-property__cpu"):
			self.cpu_class = cpu_tag["class"][1].replace("api-property__cpu--", "")
		else:
			self.cpu_class = None
		self.tag_start = 1
		self.tag_end = len(tags) - 1
		self.parse_return_tags(tags)
		self.parse_arg_info_tags(tags)
		self.description = tags_to_desc(tags[self.tag_start:self.tag_end+1])
		self.overloads = []
		overloads = filter(lambda x: x, tags[0].find(class_="api-property__args").text.split("("))
		for overload in overloads:
			args = []
			for arg in filter(lambda x: x, overload.strip().rstrip(")").split(",")):
				arg = arg.strip().rstrip(")")
				if arg.startswith("["):
					name = arg.strip("[]")
					optional = True
				else:
					name = arg
					optional = False
				args.append(JSMethod.JSArg(name, optional=optional))
			self.overloads.append(args)

	def generate_arg_type(self, arg: JSArg):
		if arg.name in self.args_info:
			return to_lua_type(self.args_info[arg.name].type)
		return "any"

	def generate_args_str(self, self_type: str, overload: list[JSArg]):
		return f"self:{self_type}{',' if len(overload) > 0 else ''}" + ",".join(f"{arg.name}:{self.generate_arg_type(arg)}{'?' if arg.optional else ''}" for arg in overload)

	def generate_comment(self, self_type: str):
		# TODO: function type
		return "\n".join([
			*((f"--- ![{self.cpu_class}](imgs/cpu_{self.cpu_class}.png) - {CPU_CLASS_DESC[self.cpu_class]}",) if self.cpu_class else ()),  # Not working with @field :(
			desc_to_comment(self.description),
			*((f"---@deprecated",) if self.deprecated else ()),  # Not working with @field :(
			f"---@field {self.name} {'|'.join([f'fun({self.generate_args_str(self_type, overload)})' + (':('+'|'.join(self.returns)+')' if len(self.returns) > 0 else '') for overload in self.overloads])}",
		])


class JSField:
	description: str
	deprecated: bool = False

	# Tag index to start and end at
	tag_start: int
	tag_end: int

	def __init__(self, name: str, type_: str, jsclass: "JSClass"):
		self.name = name
		self.type = type_
		self.jsclass = jsclass

	def __repr__(self):
		return f"<JSField {self.jsclass.name}.{self.name}: {self.type}>"

	def parse_tags(self, tags: list[Tag]):
		# See `Structure.effects`
		# TODO: If this type is array without type opts, check description for type
		#       It can contain `an array of objects with the following properties` followed by a table for example
		self.deprecated = "api-property--deprecated" in tags[0]["class"]
		self.tag_start = 1
		self.tag_end = len(tags) - 1
		self.description = tags_to_desc(tags[self.tag_start:self.tag_end+1])

	def generate_comment(self):
		return "\n".join([
			desc_to_comment(self.description),
			*((f"---@deprecated",) if self.deprecated else ()),  # Not working with @field :(
			f"---@field {self.name} {to_lua_type(self.type)}",
		])


class JSClass:
	description: str

	def __init__(self, name: str):
		self.classes: dict[str, JSClass] = {}
		self.methods: dict[str, JSMethod] = {}
		self.fields: dict[str, JSField] = {}
		self.name = name

	def __repr__(self):
		return f"<JSClass \"{self.name}\" classes={len(self.classes)} methods={len(self.methods)} fields={len(self.fields)}>"

	def parse_tags(self, tags: list[Tag]):
		print("- Parsing", self.name)
		things = sections_by_tag("h2", tags)
		self.description = tags_to_desc(things[0][1:])
		for thing in things[1:]:
			raw_path = thing[0].find(class_="api-property__name").text
			path = re.sub(rf"(\w+\.)?{self.name}\.?", "", raw_path).split(".")
			jsclass = self
			for part in path[:-1]:
				# noinspection PyUnresolvedReferences
				jsclass = jsclass.classes[part]
			name = path[-1]
			# TODO: Check for `api-property__inherited` and instead add inherited class instead of adding to this class IN <h2>
			# TODO: Check for `api-property__cpu` IN <h2> (there are various types)
			if name == "constructor":
				what = "constructor"
			else:
				what = thing[0]["class"][1].replace("api-property--", "")
			if what == "constructor":
				self.parse_constructor(jsclass, name, thing)
			elif what == "property":
				type_ = thing[0].find(class_="api-property__type").text
				if type_ == "object":
					self.parse_property_object(jsclass, name, thing)
				else:
					self.parse_property(jsclass, name, type_, thing)
			elif what == "method":
				self.parse_method(jsclass, name, thing)

	def parse_property_desc(self, tags: list[Tag]):
		tag_start, tag_end = 1, len(tags) - 1
		for i in range(tag_start, tag_end):
			tag = tags[i]
			tag_text = tag.text
			if DESC_FIELDS_REGEX["IS_FIELDS"].search(tag_text):
				tag_end = i
				for field in parse_table(tags[i + 1]):
					name, type_, desc = field["parameter"].text, field["type"].text, field["description"]
					jsfield = JSField(name, type_, self)
					jsfield.description = " ".join([str(child) for child in desc.children]).strip()
					self.fields[name] = jsfield
		self.description = tags_to_desc(tags[tag_start:tag_end+1])

	def parse_constructor(self, jsclass: "JSClass", name: str, tags: list[Tag]):
		pass  # TODO

	def parse_property(self, jsclass: "JSClass", name: str, type_: str, tags: list[Tag]):
		field = JSField(name, type_, jsclass)
		self.fields[name] = field
		field.parse_tags(tags)

	def parse_property_object(self, jsclass: "JSClass", name: str, tags: list[Tag]):
		propclass = JSClass(name)
		jsclass.classes[name] = propclass
		propclass.parse_property_desc(tags)
		# propclass.description = tags_to_desc(tags[1:])

	def parse_method(self, jsclass: "JSClass", name: str, tags: list[Tag]):
		method = JSMethod(name)
		jsclass.methods[name] = method
		method.parse_tags(tags)

	def generate(self, path: str = None):
		abs_name = f"{path + '.' if path else ''}{self.name}"
		return "\n".join([
			desc_to_comment(self.description),
			f"---@class {abs_name}",
			*[field.generate_comment() for field in self.fields.values()],
			*[field.generate_comment(abs_name) for field in self.methods.values()],
			*[field.generate_comment(path=abs_name) for field in self.classes.values()],
			f"local {self.name} = {{}}",
			"",
			* [field.generate(path=abs_name) for field in self.classes.values()],
		])

	def generate_comment(self, path: str = None):
		abs_name = f"{path + '.' if path else ''}{self.name}"
		return f"---@field {self.name} {abs_name}"


class JSConstants(JSClass):
	constants: dict[str, str]

	def parse_tags(self, tags: list[Tag]):
		print("- Parsing", self.name)
		code = tags[2].find("code").text
		sections = code.split("Object.assign(exports,")
		self.constants = {}
		for section in sections:
			section = section.strip()[:-2]  # Remove ");"
			if len(section) <= 0:
				continue
			json_str = js_type_code_to_json(section)
			try:
				data = json.loads(json_str)
			except json.JSONDecodeError:
				# print("Failed to parse as json")
				# print("- RAW -")
				# print(section)
				# print("- CLEANED -")
				# print(json_str)
				continue
			for key, value in data.items():
				if value is None:
					self.constants[key] = "any"
				else:
					self.constants[key] = json_to_type(value).replace("exports.", "")

	def generate(self, path: str = None):
		return "\n".join([
			# This produces a lot of classes, but in same cases it's needed for the types...
			# It could be done better and cleaner, but this does work.
			*[f"---@class {key} : {type_}\n{key} = nil" for key, type_ in self.constants.items()],
			"",
		])
