tool
extends HBoxContainer

export var text: String setget set_text
export var done: bool setget set_done
export var failed: bool setget set_failed

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var atlas =  AtlasTexture.new()
	atlas.region = Rect2(150, 70, 30, 30)
	$TextureRect.texture = atlas
	set_text(text)
	set_done(done)


func set_text(new_value):
	text = new_value
	if $Label != null:
		$Label.text = text

func set_done(new_value):
	done = new_value
	if $TextureRect != null:
		var atlas = ($TextureRect.texture as AtlasTexture)
		
		if done:
			set_failed(false)
			atlas.atlas = preload("res://ui/done.png")
		else:
			atlas.atlas = preload("res://ui/empty.png")

func set_failed(new_value):
	failed = new_value
	if $TextureRect != null:
		var atlas = ($TextureRect.texture as AtlasTexture)
		
		if failed:
			set_done(false)
			atlas.atlas = preload("res://ui/failed.png")
		else:
			atlas.atlas = preload("res://ui/empty.png")
