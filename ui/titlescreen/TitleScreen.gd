extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name() == "HTML5":
		$Flower/Quit.hide()
	pass # Replace with function body.





func _on_Sandbox_pressed():
	GameService.start_game()


func _on_Timelimit_pressed():
	GameService.time_limit = 5 * 60
	GameService.start_game()

func _on_Quit_pressed():
	get_tree().quit()


func _on_Settings_pressed():
	$SettingsDialog.popup_centered()
	pass # Replace with function body.


func _on_Missions_pressed():
	get_tree().change_scene("res://ui/MissionOverview.tscn")


func _on_GWJ20WC1_mouse_entered():
	if !$Tween.is_active():
		$Tween.interpolate_property($eastereggs, "position", Vector2(1830, 960), Vector2(1665, 965), .5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0)
		$Tween.interpolate_property($eastereggs, "position", Vector2(1665, 965), Vector2(1830, 960), .5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 1)
		$Tween.start()
