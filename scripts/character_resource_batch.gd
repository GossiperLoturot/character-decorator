@tool
extends EditorScript


var names := ["hairback", "base", "face", "eye", "feets", "bottom", "top", "hairfront"]


func _run():
	var pattern := RegEx.new()
	pattern.compile("^\\D+\\d+\\.png$")
	
	var all_frags := [] as Array[CharacterFrag]
	
	var dir := DirAccess.open("res://images")
	for file in dir.get_files():
		if pattern.search(file):
			var name := file.get_basename()
			var image := load("res://images".path_join(file))
			all_frags.append(CharacterFrag.new(name, image))
	
	var parts := [] as Array[CharacterPart]
	for name in names:
		var frags := [] as Array[CharacterFrag]
		for frag in all_frags:
			if frag.name.begins_with(name):
				frags.append(frag)
		
		parts.append(CharacterPart.new(name, frags))
	
	var resource := CharacterResource.new(parts)
	ResourceSaver.save(resource, "res://character_resource.tres")
