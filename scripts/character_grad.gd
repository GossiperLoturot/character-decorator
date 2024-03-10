class_name CharacterGrad
extends Resource


@export var name: String
@export var gradient: Gradient


func _init(name: String = "", gradient: Gradient = null):
	self.name = name
	self.gradient = gradient
