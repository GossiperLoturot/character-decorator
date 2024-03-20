class_name Picker
extends Node


@export var label: Label
@export var left_button: Button
@export var right_button: Button
@export var palette_button: Button

@export var palette: CanvasItem
@export var l_slider: Slider
@export var c_slider: Slider
@export var h_slider: Slider

var _text: String
var _index: int
var _size: int
var _l: float
var _c: float
var _h: float

signal pick_changed()


func _ready():
	set_property("None: %s", 1)
	left_button.pressed.connect(_prev_index)
	right_button.pressed.connect(_next_index)
	palette_button.pressed.connect(_toggle_palette)
	
	l_slider.value_changed.connect(_change_l)
	c_slider.value_changed.connect(_change_c)
	h_slider.value_changed.connect(_change_h)


func set_property(text: String, size: int):
	assert(size > 0, "size must be greater than 0")
	_text = text
	_size = size
	_index = 0
	_update_label()


func _prev_index():
	_index = clamp(_index - 1, 0, _size - 1)
	_update_label()
	pick_changed.emit()


func _next_index():
	_index = clamp(_index + 1, 0, _size - 1)
	_update_label()
	pick_changed.emit()


func _update_label():
	label.text = _text % _index


func _toggle_palette():
	palette.visible = !palette.visible


func _change_l(value: float):
	_l = value
	pick_changed.emit()


func _change_c(value: float):
	_c = value
	pick_changed.emit()


func _change_h(value: float):
	_h = value
	pick_changed.emit()


func index():
	return _index


func l():
	return _l


func c():
	return _c


func h():
	return _h
