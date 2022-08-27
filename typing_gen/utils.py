import re

from bs4.element import PageElement


def sections_by_tag(tag_name: str, tags: list[PageElement]):
	"""Split a list of page elements (tags) into sections, with each `tag_name` defining a new section."""
	output = []
	i = 0
	while i < len(tags):
		section_tags = [tags[i]]
		while i + 1 < len(tags):
			tag = tags[i + 1]
			# noinspection PyUnresolvedReferences
			if tag.name != tag_name:
				section_tags.append(tag)
				i += 1
			else:
				break
		output.append(section_tags)
		i += 1
	return output


def tags_to_desc(tags: list[PageElement]):
	return " ".join(str(tag).replace("\n", "") for tag in tags if tag.name != "pre")


def desc_to_comment(desc: str):
	return "--- " + "\n--- ".join(desc.split("\n"))


def find_tags(name: str, tags: list[PageElement], start: int = 0):
	results = []
	for i in range(start, len(tags)):
		if tags[i].name == name:
			results.append(tags[i])
	return results


# Shh, this is the most hacky thing ever...
RETURN_TYPE_CLEAN_RE = re.compile(r"//.*?\n|(?:,\s*(?!\.\.\.\s*[{\[]))?\.\.\.|/\*.*/\*")
JS_KEY_TO_JSON_RE = re.compile(r"(\w+):")
JS_VALUE_CONST_TO_JSON_RE = re.compile(r"(?<=: )([A-Z_]+)")
def return_type_code_to_json(text: str):
	return JS_VALUE_CONST_TO_JSON_RE.sub("\"\\1\"", JS_KEY_TO_JSON_RE.sub("\"\\1\":", RETURN_TYPE_CLEAN_RE.sub("", text.replace("'", "\"").replace("undefined", "null"))))
