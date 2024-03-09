class_name SelectButton
extends Node


@export var label: Label
@export var left_button: Button
@export var right_button: Button

var _text: String
var _index: int
var _size: int

signal on_update_index(index: int)


func _ready():
	set_property("None: %s", 0, 1)
	left_button.connect("pressed", on_prev_button)
	right_button.connect("pressed", on_next_button)


func set_property(text: String, index: int, size: int):
	_text = text
	_index = index
	_size = size
	update_text()


func on_prev_button():
	_index = clamp(_index - 1, 0, _size - 1)
	update_text()
	on_update_index.emit(_index)


func on_next_button():
	_index = clamp(_index + 1, 0, _size - 1)
	update_text()
	on_update_index.emit(_index)


func update_text():
	label.text = _text % _index
