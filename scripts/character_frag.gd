class_name CharacterFrag
extends Resource


@export var name: String
@export var texture: Texture2D

var _sprite_frames: SpriteFrames


func _init(name: String = "", texture: Texture2D = null):
	self.name = name
	self.texture = texture


func sprite_frames() -> SpriteFrames:
	if _sprite_frames == null:
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
		_sprite_frames = SpriteFrames.new()
		# sprite_frames.add_animation("default")
		_sprite_frames.add_frame("default", atlas_texture_array[0])
		_sprite_frames.add_animation("idle")
		_sprite_frames.add_frame("idle", atlas_texture_array[0])
		_sprite_frames.add_frame("idle", atlas_texture_array[1])
		_sprite_frames.add_animation("walk")
		_sprite_frames.add_frame("walk", atlas_texture_array[2])
		_sprite_frames.add_frame("walk", atlas_texture_array[0])
		_sprite_frames.add_frame("walk", atlas_texture_array[3])
		_sprite_frames.add_frame("walk", atlas_texture_array[0])
	
	return _sprite_frames
