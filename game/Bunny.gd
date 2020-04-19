extends AnimatedSprite

signal found


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Bunny_animation_finished():
	
	emit_signal("found")
	play("hidden")


func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		play("show")
