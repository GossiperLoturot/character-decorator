class_name Character
extends AnimatedSprite2D


func set_texture_atlas(texture: Texture2D):
	assert(texture != null, "texture is null")
	assert(texture.get_width() == 192, "texture height must be 192")
	assert(texture.get_height() == 192, "texture height must be 192")

	# create AtlasTexture
	var atlas_texture_array: Array[AtlasTexture] = []
	for y in range(2):
		for x in range(2):
			var atlas_texture := AtlasTexture.new()
			atlas_texture.atlas = texture
			atlas_texture.region = Rect2(x * 96, y * 96, 96, 96)
			atlas_texture_array.append(atlas_texture)

	# create SpriteFrames
	sprite_frames = SpriteFrames.new()
	# sprite_frames.add_animation("default")
	sprite_frames.add_frame("default", atlas_texture_array[0])
	sprite_frames.add_animation("idle")
	sprite_frames.add_frame("idle", atlas_texture_array[0])
	sprite_frames.add_frame("idle", atlas_texture_array[1])
	sprite_frames.add_animation("walk")
	sprite_frames.add_frame("walk", atlas_texture_array[2])
	sprite_frames.add_frame("walk", atlas_texture_array[0])
	sprite_frames.add_frame("walk", atlas_texture_array[3])
	sprite_frames.add_frame("walk", atlas_texture_array[0])
