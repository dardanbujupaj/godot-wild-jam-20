extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		print("play")
		play("popup")


func _on_UBoot_animation_finished():
	if animation == "popup":
		play("hidden")
