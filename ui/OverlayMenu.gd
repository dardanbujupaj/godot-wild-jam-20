extends PopupPanel



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _input(event):
	# check for escape if visible
	if Input.is_action_just_pressed("exit") and visible:
		# make sure popup is not opened again
		get_tree().set_input_as_handled()
		hide()


func _on_Resume_pressed():
	hide()


func _on_Title_pressed():
	get_tree().change_scene("res://ui/TitleScreen.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Settings_pressed():
	$SettingsDialog.popup_centered()
