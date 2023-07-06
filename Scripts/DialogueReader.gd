extends Node
class_name DialogueReader

var sections

func generate_sections(file):
	var text = file.get_as_text()
	sections = Array(text.split("::"))
	var information = sections[2]
	sections = sections.slice(3, sections.size())
	for i in range(sections.size()):
		var newSection = Section.new()
		sections[i] = sections[i].split("[[")
		newSection.title = sections[i][0].strip_edges()
		newSection.text = sections[i][0].substr(sections[i][0].find("}") + 1).strip_edges()
		newSection.title = sections[i][0].substr(0, sections[i][0].find("{") - 1).strip_edges()
		newSection.options = sections[i].slice(1, sections[i].size())
		newSection.links = {}
		for j in range(newSection.options.size()):
			newSection.options[j] = newSection.options[j].strip_edges().trim_suffix("]]")
			var divider = newSection.options[j].find("|")
			if (divider != -1):
				newSection.links[j] = newSection.options[j].substr(divider+1, newSection.options[j].length())
				newSection.options[j] = newSection.options[j].substr(0, divider)
			else:
				newSection.links[j] = newSection.options[j]
		sections[i] = newSection
	return sections

func get_first_section(file):
	var text = file.get_as_text()
	var index = text.find("start")
	var slice = text.substr(index+9)
	var end = slice.find("\"")
	var title = slice.substr(0, end)
	return get_section(title)

func get_section(title):
	for i in range(sections.size()):
		if (sections[i].title == title):
			return sections[i]

class Section:
	# Title: the name of a dialogue section, by which it is found
	# Text: the text displayed
	# Options: options the player can choose from
	# Links: where the option leads
	var title
	var text
	var options
	var links
