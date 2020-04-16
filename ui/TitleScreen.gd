extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_Sandbox_pressed():
	GameService.start_game()


func _on_Timelimit_pressed():
	GameService.time_limit = 65
	GameService.start_game()

func _on_Quit_pressed():
	get_tree().quit()


func _on_Settings_pressed():
	$SettingsDialog.popup_centered()
	pass # Replace with function body.
