from bs4 import BeautifulSoup

from utils import sections_by_tag
from js_class import JSClass, JSConstants

# https://docs.screeps.com/api/
# In google chrome (Unsure about other browsers) `RMB -> Save As`
HTML_FILE = "./Screeps Documentation.html"


EXCLUDED_CLASSES = [
	"Memory"
]


with open(HTML_FILE, "r") as f:
	bs = BeautifulSoup(f, "html.parser")

content = bs.find(class_="content api-content")
classes: dict[str, JSClass] = {}  # Top-level classes
for class_tags in sections_by_tag("h1", content.find_all(recursive=False)):
	path = class_tags[0].text.split(".")
	subclass_classes = classes
	for part in path[:-1]:
		subclass_classes = subclass_classes[part].classes
	if len(path) == 1 and path[0] == "Constants":
		jsclass = JSConstants(path[-1])
	else:
		jsclass = JSClass(path[-1])
	subclass_classes[path[-1]] = jsclass
	jsclass.parse_tags(class_tags)


print()

for _, jsclass in classes.items():
	path = f"../typing/{jsclass.name}.lua"
	print(f"- Writing \"{path}\" {jsclass}")
	if not jsclass.name in EXCLUDED_CLASSES:
		code = jsclass.generate()
		with open(path, "w") as f:
			f.write(f"-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.\n\n\n{code}")

print()

# This file is used to create the `JS_CONSTANTS` variable for the C++ side of things.
print("- Writing \"constants.txt\"")
with open("constants.txt", "w") as f:
	# noinspection PyTypeChecker
	jsconstants: JSConstants = classes["Constants"]
	for key in jsconstants.constants.keys():
		f.write(f"{key}\n")
