class_name Character
extends Node2D


@export var resource: CharacterResource

var _nodes: Array[AnimatedSprite2D]
var _textures: Array[GradientTexture1D]
var _frags: Array[int]
var _grads: Array[int]


func _ready():
	_nodes = []
	_textures = []
	_frags = []
	_grads = []
	
	var shader := preload("res://character.gdshader")
	for part in resource.parts:
		var node := AnimatedSprite2D.new()
		node.name = part.name
		node.material = ShaderMaterial.new()
		node.material.shader = shader
		node.material.set_shader_parameter("gradient", GradientTexture1D.new())
		add_child(node)
		_nodes.append(node)
		_textures.append(node.material.get_shader_parameter("gradient"))
		
		_frags.append(0)
		_grads.append(0)
		
	_apply()


func _apply():
	for i in range(resource.parts.size()):
		var part := resource.parts[i]
		
		var frag := part.frags[_frags[i]]
		_nodes[i].sprite_frames = frag.sprite_frames()
		
		var grad := part.grads[_grads[i]]
		_textures[i].gradient = grad.gradient


func get_frags():
	return _frags.duplicate()


func get_grads():
	return _grads.duplicate()


func set_frags(frags: Array[int]):
	_frags = frags.duplicate()
	_apply()


func set_grads(grads: Array[int]):
	_grads = grads.duplicate()
	_apply()


func set_animation(animation_name: String):
	for node in _nodes:
		node.frame = 0
		node.play(animation_name)


func set_flip(flip: bool):
	for node in _nodes:
		node.flip_h = flip
