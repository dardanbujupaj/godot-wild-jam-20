tool
extends Area2D

signal pressed

export var text: String setget set_text


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


	
func set_text(new_value):
	text = new_value
	$Label.text = text



func _on_Seed_mouse_entered():
	print("entered")
	scale = Vector2(1.1, 1.1)
	pass # Replace with function body.


func _on_Seed_mouse_exited():
	scale = Vector2(1, 1)
	pass # Replace with function body.


func _on_Seed_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		emit_signal("pressed")
