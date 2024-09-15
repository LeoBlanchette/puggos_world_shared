
@tool

## This class creates an analysis of a given mod and it's path. 
## It is a helper for validating or checking mod properties.
## Remember the standard mod path hierarchy below:
## </mods/<creator>/<project>/<mod_type>/<mod_type_category>/<object>/<object>.tscn , .png | etc
## 1: creator           - the main author of a set of projects.
## 2: project           - the project of a given mod. Can be an individual thing or a set.
## 3: mod_type          - a broad category of related things. Each "mod type" has it's own id set starting from 1. 
## 4: mod_type_category - a more specific drilldown of the top ID category.
## 5: mod_name          - the individual mod object. Such as a wall, an item, etc.

class_name ModAnalysis

#region validation
var is_mod_path_valid = false
var is_mod_meta_valid = false
var has_mod_name = false
#endregion 

#region hierarchy
var path:String = ""
var creator:String = ""
var project:String = ""
var mod_type:String = ""
var mod_type_category:String = ""
var mod_name:String = ""
var file_name:String = ""
#endregion 

#region meta data
var id = 0
var name = ""
#endregion 

#region console output
var console_output:Array[String] = []
#endregion 

func _init(_path:String) -> void:
	path = _path
	set_mod_hierarchy()
	set_mod_meta()

func set_mod_hierarchy():
	var path_cleaned = path.replace("res://mods/", "")
	var path_parts:PackedStringArray = path_cleaned.split("/")
	if path_parts.size() == 6:
		is_mod_path_valid = true
	else:
		return
	creator = path_parts[0]
	project = path_parts[1]
	mod_type = path_parts[2]
	mod_type_category = path_parts[3]
	mod_name = path_parts[4]
	file_name = path_parts[5]
	
func set_mod_meta():
	var ob = load(path).instantiate()
	id = ob.get_meta("id", 0)
	if id > 0:
		is_mod_meta_valid = true
	name = ob.get_meta("name", "")
	if not name.is_empty():
		has_mod_name = true
	ob.queue_free()

## This checks against the two biggest factors: ID and Path.
## If either are wrong, returns false.
func is_mod_valid()->bool:
	if not is_mod_path_valid:
		return false
	if not is_mod_meta_valid:
		return false
	return true

func print_validation_warnings():
	var warning = ""
	if not is_mod_path_valid:
		warning += "INVALID_PATH..."
		warning += "Path must follow pattern of </mods/<creator>/<project>/<mod_type>/<mod_type_category>/<object>/<object>.tscn , .png | etc\n"
	if not is_mod_meta_valid:
		if id == 0:
			warning += "ID = 0 (meta data). Please provide an appropriate ID.\n"
	if name.is_empty():
		warning += "Mod Name is empty (meta data)."
	if not warning.is_empty():
		print("\n")
		add_to_console_output(TextOps.color_text("[b]Mod Validation Warning:[/b]", Color.YELLOW))
		add_to_console_output(TextOps.color_text(path, Color.INDIAN_RED))
		print(warning)
		
	print_to_console()


func add_to_console_output(line:String):
	console_output.append(line)
	
func print_to_console():
	TextOps.print_text_array_to_console(console_output)
