extends Node

@onready var file = FileAccess.open("res://Dialogues/Bug Game Pilot.txt", FileAccess.READ)

func _ready():
	var text = file.get_as_text()
	var sections = Array(text.split("::"))
	var information = sections[2]
	sections = sections.slice(3, sections.size())
	for i in range(sections.size()):
		var newSection = Section.new()
		newSection.title = sections[i].split("[[")[0].strip_edges()
		newSection.sections = sections[i].split("[[").slice(1, sections[i].split("[[").size())
		sections[i] = newSection
		print(newSection.title)

class Section:
	var title
	var text
	var sections
