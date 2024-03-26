@tool
extends EditorScript

func _run():
	var root_path := "res://images"
	var dir := DirAccess.open(root_path)
	
	var items: Array[ImageBuilderDescItem] = []
	for file_name in dir.get_files():
		var file_path := root_path.path_join(file_name)
		var image: Image = ResourceLoader.load(file_path, "Image")
		
		if !image:
			continue
		
		var file_stem := file_name.split(".")[0]
		
		var item := ImageBuilderDescItem.new()
		item.name = file_stem
		item.image = image
		items.append(item)
	
	var desc = ImageBuilderDesc.new()
	desc.width = 192
	desc.height = 192
	desc.items = items
	
	ResourceSaver.save(desc, "res://image_builder.tres")
