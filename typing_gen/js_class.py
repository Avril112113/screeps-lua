import re
import json
from bs4.element import PageElement
from dataclasses import dataclass

from utils import sections_by_tag, tags_to_desc, desc_to_comment, find_tags, return_type_code_to_json


TYPE_JS_TO_LUA = {
	"object": "table",
	"array": "any[]",
}


def to_lua_type(type_: str, opts: list[str] = None):
	parts = type_.split("|")
	new_parts = []
	for part in parts:
		if opts is not None and len(opts) > 0:
			if part == "object":
				return f"table<{','.join(to_lua_type(opt) for opt in opts)}>"
			elif part == "object":
				return f"{opts[0]}[]"
			else:
				raise ValueError(f"opts supplied but type \"{part}\" doesn't support opts.")
		new_parts.append(TYPE_JS_TO_LUA.get(part, part))
	return "|".join(new_parts)


def parse_js_type(type_: str):
	parts = type_.replace(" ", "").rstrip(">").split("<", 1)
	if len(parts) > 1:
		return parts[0], parts[1].split(",")
	else:
		return parts[0], []


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
		# type: str
		# type_opts: list[str]
		optional: bool = False

	description: str
	overloads: list[list[JSArg]]
	returns: list[str]

	def __init__(self, name: str):
		self.name = name

	def parse_tags(self, tags: list[PageElement]):
		desc_end = len(tags)
		self.returns = []
		for i in range(len(tags)-1, 0, -1):
			if tags[i].text == "Return value":
				desc_end = i
				for tag in find_tags("pre", tags, start=i):
					json_str = return_type_code_to_json(tag.text)
					try:
						self.returns.append(json_to_type(json.loads(json_str)))
					except json.decoder.JSONDecodeError:
						pass
						# print("Failed to parse as json")
						# print("- RAW -")
						# print(tag.text)
						# print("- CLEANED -")
						# print(json_str)
				break
		self.description = tags_to_desc(tags[1:desc_end])
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

	def generate_args_str(self, overload: list[JSArg]):
		return ",".join(f"{arg.name}:any{'?' if arg.optional else ''}" for arg in overload)

	def generate_comment(self):
		# TODO: function type
		return "\n".join([
			desc_to_comment(self.description),
			f"---@field {self.name} {'|'.join([f'fun({self.generate_args_str(overload)})' + (':('+'|'.join(self.returns)+')' if len(self.returns) > 0 else '') for overload in self.overloads])}",
		])


class JSField:
	type: str
	type_opts: list[str]  # [elem_type] [key_type, value_type]
	description: str

	def __init__(self, name: str):
		self.name = name

	def parse_type_str(self, type_: str):
		self.type, self.type_opts = parse_js_type(type_)

	def parse_tags(self, tags: list[PageElement]):
		# See `Structure.effects`
		# TODO: If this type is array or object without type opts, check description for type
		#       It can contain `an array of objects with the following properties` followed by a table for example
		self.description = tags_to_desc(tags[1:])

	def generate_comment(self):
		return "\n".join([
			desc_to_comment(self.description),
			f"---@field {self.name} {to_lua_type(self.type, self.type_opts)}",
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

	def parse_tags(self, tags: list[PageElement]):
		print("- Parsing", self.name)
		things = sections_by_tag("h2", tags)
		self.description = tags_to_desc(things[0][1:])
		for thing in things[1:]:
			raw_path = thing[0].find(class_="api-property__name").text
			path = re.sub(rf"(\w+\.)?{self.name}\.?", "", raw_path).split(".")
			jsclass = self
			for part in path[:-1]:
				jsclass = jsclass.classes[part]
			name = path[-1]
			# TODO: Check for `api-property__inherited` and instead add inherited class instead of adding to this class IN <h2>
			# TODO: Check for `api-property--deprecated` ON <h2>
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

	def parse_constructor(self, jsclass: "JSClass", name: str, tags: list[PageElement]):
		pass

	def parse_property(self, jsclass: "JSClass", name: str, type_: str, tags: list[PageElement]):
		field = JSField(name)
		self.fields[name] = field
		field.parse_type_str(type_)
		field.parse_tags(tags)

	def parse_property_object(self, jsclass: "JSClass", name: str, tags: list[PageElement]):
		propclass = JSClass(name)
		jsclass.classes[name] = propclass
		propclass.description = tags_to_desc(tags[1:])

	def parse_method(self, jsclass: "JSClass", name: str, tags: list[PageElement]):
		method = JSMethod(name)
		jsclass.methods[name] = method
		method.parse_tags(tags)

	def generate(self, path: str = None):
		abs_name = f"{path + '.' if path else ''}{self.name}"
		return "\n".join([
			desc_to_comment(self.description),
			f"---@class {abs_name}",
			*[field.generate_comment() for field in self.fields.values()],
			*[field.generate_comment() for field in self.methods.values()],
			*[field.generate_comment(path=abs_name) for field in self.classes.values()],
			f"local {self.name} = {{}}",
			"",
			* [field.generate(path=abs_name) for field in self.classes.values()],
		])

	def generate_comment(self, path: str = None):
		abs_name = f"{path + '.' if path else ''}{self.name}"
		return f"---@field {self.name} {abs_name}"
