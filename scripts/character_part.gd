class_name CharacterPart
extends Resource


@export var name: String
@export var frags: Array[CharacterFrag]
@export var grads: Array[CharacterGrad]


func _init(name: String = "", frags: Array[CharacterFrag] = [], grads: Array[CharacterGrad] = []):
	self.name = name
	self.frags = frags
	self.grads = grads
