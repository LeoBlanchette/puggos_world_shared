@tool

## Accounts the IDs used in the SDK.
class_name IdTracker

var mods:Array[ModAnalysis]
var creators_with_ids:Dictionary = {}
var console_output:Array[String]

func _init() -> void:
	get_all_mods()

func analyze_mods():
	distribute_mod_ids_via_creator()
	validate_mods_by_creator()

	
func get_all_mods():
	var mods_tscn_paths:Array = FileOps.get_all_files_recursive("res://mods/", "tscn")
	for mods_tscn_path in mods_tscn_paths:
		var mod:ModAnalysis = ModAnalysis.new(mods_tscn_path)
		#mod.print_validation_warnings()
		mods.append(mod)
		
func distribute_mod_ids_via_creator():
	for mod in mods:
		if not creators_with_ids.has(mod.creator):
			creators_with_ids[mod.creator]=[]
		creators_with_ids[mod.creator].append(mod.id)
	
func validate_mods_by_creator():
	for creator:String in creators_with_ids:
		validate_creator_ids(creator)

## A string-heavy method that validates the ids and prints the 
## Analysis to the console.
func validate_creator_ids(creator:String):
	add_to_console_output(TextOps.color_text("-- -- -- -- -- -- -- -- -- --", Color.LIGHT_SLATE_GRAY))
	add_to_console_output(TextOps.color_text("[color=LIME_GREEN]Creator:[/color] %s"%creator.to_upper(), Color.GREEN))
	var creator_mods:Array[ModAnalysis]
	var mod_categories:Dictionary = {}
	for mod in mods:
		if mod.creator == creator:
			creator_mods.append(mod)
	
	for creator_mod in creator_mods:
		if not mod_categories.has(creator_mod.mod_type):
			mod_categories[creator_mod.mod_type] = []
		mod_categories[creator_mod.mod_type].append(creator_mod)
		
	for mod_type:String in mod_categories:
		var highest_id:int = 0
		var found_ids:Array[int]=[]
		var duplicate_ids:Array[int]=[]
		for mod:ModAnalysis in mod_categories[mod_type]:
			if mod.id > highest_id:
				highest_id = mod.id
			if found_ids.has(mod.id):
				duplicate_ids.append(mod.id)
			found_ids.append(mod.id)
		var mod_type_string:String = TextOps.color_text("	[color=orange]Mod Type[/color]: %s"%mod_type, Color.CORAL)
		var highest_id_string:String = TextOps.color_text("		[color=KHAKI]Highest ID:[/color] %s"%str(highest_id), Color.YELLOW)
		add_to_console_output(mod_type_string)
		add_to_console_output(highest_id_string)
		if not duplicate_ids.is_empty():
			add_to_console_output(TextOps.color_text("	Duplicate IDs:", Color.RED))
			for duplicate_id:int in duplicate_ids:
				var duplicate_id_mods:Array[ModAnalysis] = get_all_mods_by_id(creator, mod_type, duplicate_id)
				add_to_console_output("		[b]%s[/b], found at:"%TextOps.color_text(str(duplicate_id), Color.ORANGE_RED))
				for duplicate:ModAnalysis in duplicate_id_mods:
					add_to_console_output("			%s"%duplicate.path)



## Gets mods by ID. This is used mainly for finding duplicates, but can also be a 
## general getter.
func get_all_mods_by_id(creator:String, mod_type:String, id:int)->Array[ModAnalysis]:
	var matching_mods_by_id:Array[ModAnalysis] = []
	for mod:ModAnalysis in mods:
		if mod.creator == creator && mod.mod_type == mod_type && mod.id == id:
			matching_mods_by_id.append(mod)
	return matching_mods_by_id

func add_to_console_output(line:String):
	console_output.append(line)
	
func print_to_console():
	TextOps.print_text_array_to_console(console_output)
