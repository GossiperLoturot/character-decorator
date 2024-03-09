class_name CharacterPart
extends Resource


@export var name: String
@export var frags: Array[CharacterFrag]


func _init(name: String = "", frags: Array[CharacterFrag] = []):
	self.name = name
	self.frags = frags
