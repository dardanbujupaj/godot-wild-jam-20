extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$godot.linear_velocity = Vector2(rand_range(-1000, 1000), rand_range(-1000, 1000))
	pass # Replace with function body.


func _input(event):
	if Input.is_action_just_pressed("exit"):
		_popup_overlay_menu()
		


func _popup_overlay_menu():
	$OverlayMenu.popup_centered()



func _on_Area2D_mouse_entered():
	print("entered")
	pass # Replace with function body.




func _on_OverlayMenu_about_to_show():
	get_tree().paused = true
	pass # Replace with function body.


func _on_OverlayMenu_popup_hide():
	get_tree().paused = false
	pass # Replace with function body.
