class_name Character
extends Node2D


@export var resource: CharacterResource

var _nodes: Array[AnimatedSprite2D]
var _data: Array[int]


func _ready():
	_nodes = []
	_data = []
	
	for part in resource.parts:
		var node := AnimatedSprite2D.new()
		node.name = part.name
		add_child(node)
		_nodes.append(node)
		
		_data.append(0)
		
	_apply_data()


func _apply_data():
	for i in range(resource.parts.size()):
		var part := resource.parts[i]
		var frag := part.frags[_data[i]]
		_nodes[i].sprite_frames = frag.sprite_frames()


func get_data():
	return _data.duplicate()


func set_data(data: Array[int]):
	_data = data.duplicate()
	_apply_data()


func set_animation(animation_name: String):
	for node in _nodes:
		node.frame = 0
		node.play(animation_name)


func set_flip(flip: bool):
	for node in _nodes:
		node.flip_h = flip
