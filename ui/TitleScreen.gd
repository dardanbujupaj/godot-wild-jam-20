extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_Sandbox_pressed():
	
	get_tree().change_scene("res://game/Game.tscn")
	pass # Replace with function body.


func _on_Timelimit_pressed():
	pass # Replace with function body.

func _on_Quit_pressed():
	get_tree().quit()
	pass # Replace with function body.
