extends Node


var fragment_names: Array[String]
var fragment_res: Dictionary
var fragment_idx: Dictionary
var character: Node


func _ready():
	fragment_names = [
		"base",
		"bottom",
		"top",
		"feets",
		"eyes",
		"hairfront",
		"hairback",
	]
	
	fragment_res = {
		"base": [
			load("res://img/base00.png"),
		],
		"bottom": [
			load("res://img/bottom00.png"),
			load("res://img/bottom01.png"),
			load("res://img/bottom02.png"),
		],
		"top": [
			load("res://img/top00.png"),
			load("res://img/top01.png"),
			load("res://img/top02.png"),
		],
		"feets": [
			load("res://img/feets00.png"),
			load("res://img/feets01.png"),
			load("res://img/feets02.png"),
		],
		"eyes": [
			load("res://img/eyes00.png"),
			load("res://img/eyes01.png"),
			load("res://img/eyes02.png"),
			load("res://img/eyes03.png"),
		],
		"hairfront": [
			load("res://img/hairfront00.png"),
			load("res://img/hairfront01.png"),
			load("res://img/hairfront02.png"),
			load("res://img/hairfront03.png"),
			load("res://img/hairfront04.png"),
		],
		"hairback": [
			load("res://img/hairback00.png"),
			load("res://img/hairback01.png"),
			load("res://img/hairback02.png"),
			load("res://img/hairback03.png"),
			load("res://img/hairback04.png"),
		],
	}
	
	fragment_idx = {
		"base": 0,
		"bottom": 0,
		"top": 0,
		"feets": 0,
		"face": 0,
		"eyes": 0,
		"hairfront": 0,
		"hairback": 0,
	}
	
	character = $"../Node2D"
	
	update_character_texture()

func update_character_texture():
	for name in fragment_names:
		var idx = fragment_idx[name]
		var textures = fragment_res[name]
		character.call("set_character_texture", name, textures[idx])	
