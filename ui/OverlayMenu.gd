extends PopupPanel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Resume_pressed():
	hide()
	pass # Replace with function body.


func _on_Title_pressed():
	get_tree().change_scene("res://ui/TitleScreen.tscn")
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
	pass # Replace with function body.
