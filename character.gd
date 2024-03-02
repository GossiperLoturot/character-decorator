extends Node


# no static type hint
var fragment_map: Dictionary = {}


func _ready():
	for name in ["hairback", "base", "face", "bottom", "top", "feets", "hairfront", "eyes"]:
		var fragment := AnimatedSprite2D.new()
		add_child(fragment)
		fragment_map[name] = fragment


func set_character_texture(fragment_name: String, texture: Texture2D):
	assert(fragment_map.has(fragment_name), "no matching with character layout")
	var fragment: AnimatedSprite2D = fragment_map[fragment_name]
	
	assert(texture != null, "texture is null")
	assert(texture.get_width() == 192, "texture height must be 192")
	assert(texture.get_height() == 192, "texture height must be 192")
	
	# create AtlasTexture
	var atlas: Array[AtlasTexture] = []
	for y in range(2):
		for x in range(2):
			var item := AtlasTexture.new()
			item.atlas = texture
			item.region = Rect2(x * 96, y * 96, 96, 96)
			atlas.append(item)
	
	# create SpriteFrames
	var sprite_frames := SpriteFrames.new()
	# sprite_frames.add_animation("default")
	sprite_frames.add_frame("default", atlas[0])
	sprite_frames.add_animation("idle")
	sprite_frames.add_frame("idle", atlas[0])
	sprite_frames.add_frame("idle", atlas[1])
	sprite_frames.add_animation("walk")
	sprite_frames.add_frame("walk", atlas[0])
	sprite_frames.add_frame("walk", atlas[1])
	sprite_frames.add_frame("walk", atlas[2])
	sprite_frames.add_frame("walk", atlas[3])
	fragment.sprite_frames = sprite_frames
