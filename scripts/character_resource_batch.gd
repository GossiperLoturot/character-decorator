@tool
extends EditorScript


var names := ["hairback", "base", "face", "eyes", "feets", "bottom", "top", "hairfront"]


func _run():
	var pattern := RegEx.new()
	pattern.compile("^\\D+\\d+\\.png$")
	
	var all_frags := [] as Array[CharacterFrag]
	
	var dir := DirAccess.open("res://images")
	for file in dir.get_files():
		if pattern.search(file):
			var name := file.get_basename()
			var texture := load("res://images".path_join(file))
			all_frags.append(CharacterFrag.new(name, texture))
	
	var config := ConfigFile.new()
	config.load("res://images/colors.ini")
	
	var parts := [] as Array[CharacterPart]
	for name in names:
		var frags := [] as Array[CharacterFrag]
		for frag in all_frags:
			if frag.name.begins_with(name):
				frags.append(frag)
		
		var grads := [] as Array[CharacterGrad]
		for key in config.get_section_keys(name):
			var offsets := [] as Array[float]
			var colors := [] as Array[Color]
			var hexes := config.get_value(name, key, []) as Array
			for i in range(hexes.size()):
				offsets.append(i as float / (hexes.size() - 1) as float)
				colors.append(Color(hexes[i]))
			
			var grad := Gradient.new()
			grad.offsets = offsets
			grad.colors = colors
			grads.append(CharacterGrad.new(key, grad))
		
		parts.append(CharacterPart.new(name, frags, grads))
	
	var resource := CharacterResource.new(parts)
	ResourceSaver.save(resource, "res://character_resource.tres")
