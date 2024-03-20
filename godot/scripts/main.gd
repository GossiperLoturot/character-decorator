extends Node


@export var character: Character

@export var base_picker: Picker
@export var hair_picker: Picker
@export var eyes_picker: Picker
@export var top_picker: Picker
@export var bottom_picker: Picker
@export var feets_picker: Picker

@export var default_button: Button
@export var idle_button: Button
@export var walk_button: Button
@export var flip_button: Button

var _builder: ImageBuilder


func _ready():
	_builder = ImageBuilder.from_file(192, 192, "images")
	
	base_picker.set_property("Base: %s", 2)
	hair_picker.set_property("Hair: %s", 5)
	eyes_picker.set_property("Eyes: %s", 3)
	top_picker.set_property("Top: %s", 3)
	bottom_picker.set_property("Bottom: %s", 3)
	feets_picker.set_property("Feets: %s", 3)
	
	base_picker.pick_changed.connect(update_character)
	hair_picker.pick_changed.connect(update_character)
	eyes_picker.pick_changed.connect(update_character)
	top_picker.pick_changed.connect(update_character)
	bottom_picker.pick_changed.connect(update_character)
	feets_picker.pick_changed.connect(update_character)
	
	default_button.pressed.connect(func(): character.play("default"))
	idle_button.pressed.connect(func(): character.play("idle"))
	walk_button.pressed.connect(func(): character.play("walk"))
	flip_button.pressed.connect(func(): character.flip_h = !character.flip_h)
	
	update_character()


func update_character():
	_builder.clear_pick()
	
	var name = ""
	
	name = ["hairback00", "hairback01", "hairback02", "hairback03", "hairback04"][hair_picker.index()]
	_builder.add_pick(name, hair_picker.l() * 0.01, hair_picker.c() * 0.01, hair_picker.h())
	name = ["base00", "base01"][base_picker.index()]
	_builder.add_pick(name, base_picker.l() * 0.01, base_picker.c() * 0.01, base_picker.h())
	name = ["eyes00", "eyes01", "eyes02"][eyes_picker.index()]
	_builder.add_pick(name, 0.0, 0.0, 0.0)
	name = ["iris00", "iris01", "iris02"][eyes_picker.index()]
	_builder.add_pick(name, eyes_picker.l() * 0.01, eyes_picker.c() * 0.01, eyes_picker.h())
	name = ["bottom00", "bottom01", "bottom02"][bottom_picker.index()]
	_builder.add_pick(name, bottom_picker.l() * 0.01, bottom_picker.c() * 0.01, bottom_picker.h())
	name = ["top00", "top01", "top02"][top_picker.index()]
	_builder.add_pick(name, top_picker.l() * 0.01, top_picker.c() * 0.01, top_picker.h())
	name = ["feets00", "feets01", "feets02"][feets_picker.index()]
	_builder.add_pick(name, feets_picker.l() * 0.01, feets_picker.c() * 0.01, feets_picker.h())
	name = ["hairfront00", "hairfront01", "hairfront02", "hairfront03", "hairfront04"][hair_picker.index()]
	_builder.add_pick(name, hair_picker.l() * 0.01, hair_picker.c() * 0.01, hair_picker.h())
	
	var image = _builder.build()
	var texture = ImageTexture.create_from_image(image)
	character.set_texture_atlas(texture)
