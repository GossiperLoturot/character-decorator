class_name Picker
extends Node


@export var label: Label
@export var left_button: Button
@export var right_button: Button

var _text: String
var _index: int
var _size: int

signal on_change(index: int)


func _ready():
	set_property("None: %s", 1)
	left_button.connect("pressed", on_prev_button)
	right_button.connect("pressed", on_next_button)


func index():
	return _index


func set_property(text: String, size: int):
	assert(size > 0, "size must be greater than 0")
	_text = text
	_size = size
	_index = 0
	update_label()


func on_prev_button():
	_index = clamp(_index - 1, 0, _size - 1)
	update_label()
	
	on_change.emit(_index)


func on_next_button():
	_index = clamp(_index + 1, 0, _size - 1)
	update_label()
	
	on_change.emit(_index)


func update_label():
	label.text = _text % _index
