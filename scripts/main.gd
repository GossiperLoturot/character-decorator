extends Node


@export var character: Character
@export var hair_select_button: SelectButton
@export var eyes_select_button: SelectButton
@export var face_select_button: SelectButton
@export var top_select_button: SelectButton
@export var bottom_select_button: SelectButton
@export var feets_select_button: SelectButton

var _data: Array[int]


func _ready():
	_data = character.get_data()
	
	hair_select_button.set_property("Hair: %s", 0, 6)
	hair_select_button.on_update_index.connect(func (index: int):
		_update_index(0, index)
		_update_index(7, index)
	)
	
	eyes_select_button.set_property("Eyes: %s", 0, 3)
	eyes_select_button.on_update_index.connect(func (index: int):
		_update_index(3, index)
	)
	
	face_select_button.set_property("Face: %s", 0, 2)
	face_select_button.on_update_index.connect(func (index: int):
		_update_index(2, index)
	)
	
	top_select_button.set_property("Top: %s", 0, 3)
	top_select_button.on_update_index.connect(func (index: int):
		_update_index(6, index)
	)
	
	bottom_select_button.set_property("Bottom: %s", 0, 3)
	bottom_select_button.on_update_index.connect(func (index: int):
		_update_index(5, index)
	)
	
	feets_select_button.set_property("Feets: %s", 0, 3)
	feets_select_button.on_update_index.connect(func (index: int):
		_update_index(4, index)
	)


func _update_index(part_index: int, frag_index: int):
	_data[part_index] = frag_index
	character.set_data(_data)
	character.set_animation("walk")
