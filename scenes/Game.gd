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
		_toggle_overlay_menu()
		


func _toggle_overlay_menu():
	if $OverlayMenu.is_visible_in_tree():
		$OverlayMenu.hide()
	else:
		$OverlayMenu.popup_centered()



func _on_Area2D_mouse_entered():
	print("entered")
	pass # Replace with function body.
