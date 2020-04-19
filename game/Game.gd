extends Node2D

signal found

onready var selection_helper = $SelectionHelper
onready var tutorials = $UI/Tutorials

enum {
	MODE_FREE,
	MODE_TIMELIMIT,
	MODE_GOAL,
	MODE_MISSION,
}

var game_mode = MODE_FREE

var game_over = false

var goal_count

var goal_eastereggs = false

var eastereggs_found = {
	"catsdogs": false,
	"bunny": false,
	"uboot": false
}

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameService.time_limit != null:
		$TimelimitTimer.start(GameService.time_limit)
	else:
		$UI/PanelContainer/VBoxContainer/HBoxTimer.hide()
	
	
	goal_count = GameService.goal_count
	
	goal_eastereggs = GameService.goal_eastereggs
	
	if not goal_eastereggs:
		$UI/PanelContainer/VBoxContainer/HBoxEggCounter.hide()
	
	# place starting dandelions
	add_dandelion(Vector2(0, 0))
	
	
	GameService.reset()
	
	if GameService.bug:
		var instance = preload("res://game/bug/Bug.tscn").instance()
		instance.position = Vector2(-400, -400)
		add_child(instance)
		
	if GameService.bee:
		var instance = preload("res://game/bug/Bee.tscn").instance()
		instance.position = Vector2(400, -400)
		add_child(instance)
	
	
	
	connect("found", self, "easteregg_found", ["catsdogs"])
	$ParallaxBackground/ParallaxLayer/Bunny.connect("found", self, "easteregg_found", ["bunny"])
	$ParallaxBackground/ParallaxLayer/UBoot.connect("found", self, "easteregg_found", ["uboot"])


func easteregg_found(name):
	eastereggs_found[name] = true
	
	print("eastereggs " + str(eastereggs_found))

func restart():
	print("restart not implemented")




func _refresh_panel():
	$UI/PanelContainer.hide()
	$UI/PanelContainer.show()



func _input(event):
	# open overlay menu when "escape" is pressed
	if Input.is_action_just_pressed("exit"):
		_popup_overlay_menu()
	
	if Input.is_key_pressed(KEY_F):
		add_dandelion(get_global_mouse_position())



func _unhandled_input(event):
	if Input.is_action_just_pressed("click"):
		var zoom_out = true
		
		for node in selection_helper.get_overlapping_areas():
			if node is Dandelion:
				
				zoom_out = false
				$Camera.zoom_to(node)
		
		if zoom_out:
			$Camera.zoom_out()




func _process(delta):
	# update selection helper
	selection_helper.position = get_global_mouse_position()
	
	check_and_update_stats()
	
	if $Cloud.rain_phase == "catsdogs":
		$ParallaxBackground/ParallaxLayer/background/Sprechblase.show()
		emit_signal("found")
	else:
		$ParallaxBackground/ParallaxLayer/background/Sprechblase.hide()




func check_and_update_stats():
	# update dandelion counter
	var dandelion_count = len(get_tree().get_nodes_in_group("dandelions"))
	var seed_count = len(get_tree().get_nodes_in_group("seeds"))
	
	
	if dandelion_count == 0 and seed_count == 0:
		tutorials.show_tutorial("better_luck_this_time")
		add_dandelion(Vector2())
	
	var counter_text = str(dandelion_count)
	
	if goal_count != null:
		counter_text += "/" + str(goal_count)
	
	$UI/PanelContainer/VBoxContainer/HBoxCounter/DandelionCounter.text = counter_text 
	
	# update timer
	var time_left = $TimelimitTimer.time_left
	var hours = int(time_left / 3600)
	var minutes = int(time_left / 60) % 60
	var seconds = int(time_left) % 60
	
	var time_string
	if hours > 0:
		time_string = "%d:%02d:%02d" % [hours, minutes, seconds]
	else:
		time_string = "%d:%02d" % [minutes, seconds]
		
	$UI/PanelContainer/VBoxContainer/HBoxTimer/Timer.text = time_string
	
	
	if goal_count != null and dandelion_count >= goal_count:
		end_game(true)
		
	
	
	var eggcount = 0
	if goal_eastereggs:
		var all_found = true
		
		for egg in eastereggs_found.keys():
			if not eastereggs_found[egg]:
				all_found = false
			else:
				eggcount += 1
		
		$UI/PanelContainer/VBoxContainer/HBoxEggCounter/Counter.text = str(eggcount)
		
		if all_found:
			end_game(true)
		
		





# open the overlay menu
func _popup_overlay_menu():
	$UI/OverlayMenu.popup_centered()


# add a new dandelion at position
func add_dandelion(position):
	var dandelion = preload("res://game/dandelion/Dandelion.tscn").instance()
	
	dandelion.position = position
	# dandelion.connect("input_event", self, "_on_Dandelion_input_event", [dandelion])
	
	add_child(dandelion)
	
	tutorials.show_tutorial("zoom_to_dandelion")
	


var seed_scene = load("res://game/seed/Seed.tscn")

func release_seeds(release_position, amount):
	for _i in range(amount):
		var seed_instance = seed_scene.instance()
		seed_instance.position = release_position
		add_child(seed_instance)



func end_game(game_won: bool):
	
	get_tree().paused = true
	game_over = true
	
	if game_won:
		GameService.mission_success = true
		$UI/GameOverPopup/MarginContainer/VBoxContainer/Label.text = "You won!"
	else:
		GameService.mission_success = false
		$UI/GameOverPopup/MarginContainer/VBoxContainer/Label.text = "You lost!"
		
	$UI/GameOverPopup.popup_centered()
	


# pause and unpause game depending ond overlay menu
func _on_OverlayMenu_about_to_show():
	get_tree().paused = true


func _on_OverlayMenu_popup_hide():
	if !game_over:
		get_tree().paused = false




func _on_WindRight_pressed():
	pass# $Cloud.velocity = Vector2(1, 0)


func _on_WindLeft_pressed():
	pass# $Cloud.velocity = Vector2(-1, 0)


func play_wind_sound():
	var wind_sounds = [
		preload("res://game/sound/Sound_03_WindBG1.wav"),
		preload("res://game/sound/Sound_04_WindLN1.wav"),
		preload("res://game/sound/Sound_05_WindLN2.wav")
	]
	$SoundEffectPlayer.stream = wind_sounds[randi() % len(wind_sounds)]
	$SoundEffectPlayer.play()

func _on_WindRight_button_down():
	play_wind_sound()
	$Cloud.accelerate_right()
	get_tree().call_group("dandelions", "blow_right")
	get_tree().call_group("seeds", "blow_right")
	
	$Camera.follow($Cloud)
	
func _on_WindLeft_button_down():
	play_wind_sound()
	$Cloud.accelerate_left()
	get_tree().call_group("dandelions", "blow_left")
	get_tree().call_group("seeds", "blow_left")
	
	$Camera.follow($Cloud)


func _on_Wind_button_up():
	get_tree().call_group("dandelions", "stop_blowing")
	get_tree().call_group("seeds", "stop_blowing")
	$Camera.follow(null)
	$Cloud.stop_accelerating()


func _on_TimelimitTimer_timeout():
	end_game(false)
	pass # Replace with function body.


func _on_Back_pressed():
	get_tree().paused = false
	GameService.back()


func _on_Restart_pressed():
	restart()


