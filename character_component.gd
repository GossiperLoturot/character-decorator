extends AnimatedSprite2D


@export var texture: Texture2D

func _ready():
	assert(texture != null, "texture is null")
	assert(texture.get_width() == 192, "texture height must be 192")
	assert(texture.get_height() == 192, "texture height must be 192")
	
	# create AtlasTexture
	var atlas = Array()
	var entries = [Vector2(0, 0), Vector2(0, 1), Vector2(1, 0), Vector2(1, 1)]
	for entry in entries:
		var item = AtlasTexture.new()
		item.atlas = texture
		item.region = Rect2(entry.x * 96, entry.y * 96, 96, 96)
		atlas.append(item)
	
	# create SpriteFrames
	sprite_frames = SpriteFrames.new()
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
