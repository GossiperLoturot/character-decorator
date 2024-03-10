extends Node


@export var character: Character

@export var hair_type_select_button: SelectButton
@export var eyes_type_select_button: SelectButton
@export var face_type_select_button: SelectButton
@export var top_type_select_button: SelectButton
@export var bottom_type_select_button: SelectButton
@export var feets_type_select_button: SelectButton

@export var base_color_select_button: SelectButton
@export var hair_color_select_button: SelectButton
@export var eyes_color_select_button: SelectButton
@export var top_color_select_button: SelectButton
@export var bottom_color_select_button: SelectButton
@export var feets_color_select_button: SelectButton

@export var default_animation_button: Button
@export var idle_animation_button: Button
@export var walk_animation_button: Button

var _frags: Array[int]
var _grads: Array[int]


func _ready():
	_frags = character.get_frags()
	_grads = character.get_grads()
	
	# type
	
	hair_type_select_button.set_property("Hair: %s", 0, 6)
	hair_type_select_button.on_update_index.connect(func (index: int):
		_update_frag_index(0, index)
		_update_frag_index(7, index)
	)
	
	eyes_type_select_button.set_property("Eyes: %s", 0, 3)
	eyes_type_select_button.on_update_index.connect(func (index: int):
		_update_frag_index(3, index)
	)
	
	face_type_select_button.set_property("Face: %s", 0, 2)
	face_type_select_button.on_update_index.connect(func (index: int):
		_update_frag_index(2, index)
	)
	
	top_type_select_button.set_property("Top: %s", 0, 3)
	top_type_select_button.on_update_index.connect(func (index: int):
		_update_frag_index(6, index)
	)
	
	bottom_type_select_button.set_property("Bottom: %s", 0, 3)
	bottom_type_select_button.on_update_index.connect(func (index: int):
		_update_frag_index(5, index)
	)
	
	feets_type_select_button.set_property("Feets: %s", 0, 3)
	feets_type_select_button.on_update_index.connect(func (index: int):
		_update_frag_index(4, index)
	)
	
	# color
	
	base_color_select_button.set_property("Bace: %s", 0, 3)
	base_color_select_button.on_update_index.connect(func (index: int):
		_update_grad_index(1, index)
		_update_grad_index(2, index)
	)
	
	hair_color_select_button.set_property("Hair: %s", 0, 4)
	hair_color_select_button.on_update_index.connect(func (index: int):
		_update_grad_index(0, index)
		_update_grad_index(7, index)
	)
	
	eyes_color_select_button.set_property("Eyes: %s", 0, 7)
	eyes_color_select_button.on_update_index.connect(func (index: int):
		_update_grad_index(3, index)
	)
	
	top_color_select_button.set_property("Top: %s", 0, 1)
	top_color_select_button.on_update_index.connect(func (index: int):
		_update_grad_index(6, index)
	)
	
	bottom_color_select_button.set_property("Bottom: %s", 0, 1)
	bottom_color_select_button.on_update_index.connect(func (index: int):
		_update_grad_index(5, index)
	)
	
	feets_color_select_button.set_property("Feets: %s", 0, 1)
	feets_color_select_button.on_update_index.connect(func (index: int):
		_update_grad_index(4, index)
	)
	
	# animation
	
	default_animation_button.pressed.connect(func ():
		character.set_animation("default")
	)
	
	idle_animation_button.pressed.connect(func ():
		character.set_animation("idle")
	)
	
	walk_animation_button.pressed.connect(func ():
		character.set_animation("walk")
	)


func _update_frag_index(part_index: int, frag_index: int):
	_frags[part_index] = frag_index
	character.set_frags(_frags)


func _update_grad_index(part_index: int, grad_index: int):
	_grads[part_index] = grad_index
	character.set_grads(_grads)
