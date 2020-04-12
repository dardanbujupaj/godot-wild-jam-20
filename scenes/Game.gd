extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var start_dandelion = add_dandelion(Vector2(0, 0))
	add_dandelion(Vector2(200, 0))

func _input(event):
	if Input.is_action_just_pressed("exit"):
		_popup_overlay_menu()
		


func _popup_overlay_menu():
	$UI/OverlayMenu.popup_centered()



func add_dandelion(position):
	var dandelion = preload("res://scenes/Dandelion.tscn").instance()
	
	dandelion.position = position
	dandelion.connect("input_event", self, "_on_Dandelion_input_event", [dandelion])
	add_child(dandelion)
	return dandelion




func _on_Area2D_mouse_entered():
	print("entered")
	pass # Replace with function body.




func _on_OverlayMenu_about_to_show():
	get_tree().paused = true
	pass # Replace with function body.


func _on_OverlayMenu_popup_hide():
	get_tree().paused = false
	pass # Replace with function body.




func _on_WindRight_pressed():
	print("move right")
	$Cloud.velocity = Vector2(1, 0)
	pass # Replace with function body.


func _on_WindLeft_pressed():
	$Cloud.velocity = Vector2(-1, 0)
	pass # Replace with function body.





func _on_Dandelion_input_event(viewport, event, shape_idx, dandelion):
	if Input.is_action_just_pressed("click"):
		if dandelion.active:
			$Camera.zoom_out()
		else:
			$Camera.zoom_to(dandelion)
	pass # Replace with function body.
