extends Node2D

onready var selection_helper = $SelectionHelper

enum {
	MODE_FREE,
	MODE_TIMELIMIT,
	MODE_GOAL,
	MODE_MISSION,
}

var game_mode = MODE_FREE

var game_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameService.time_limit != null:
		$TimelimitTimer.start(GameService.time_limit)
	else:
		$UI/PanelContainer/VBoxContainer/HBoxTimer.hide()
	
	# place starting dandelions
	add_dandelion(Vector2(0, 0))
	
	GameService.reset()

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
				print("zoom to %s" % node)
				zoom_out = false
				$Camera.zoom_to(node)
				break
		
		if zoom_out:
			$Camera.zoom_out()


func _process(delta):
	# update selection helper
	selection_helper.position = get_global_mouse_position()
	
	check_and_update_stats()

func check_and_update_stats():
	# update dandelion counter
	var dandelion_count = get_tree().get_nodes_in_group("dandelions")
	$UI/PanelContainer/VBoxContainer/HBoxCounter/DandelionCounter.text = str(len(dandelion_count))
	
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


# open the overlay menu
func _popup_overlay_menu():
	$UI/OverlayMenu.popup_centered()


# add a new dandelion at position
func add_dandelion(position):
	var dandelion = preload("res://game/dandelion/Dandelion.tscn").instance()
	
	dandelion.position = position
	# dandelion.connect("input_event", self, "_on_Dandelion_input_event", [dandelion])
	
	add_child(dandelion)


var seed_scene = load("res://game/seed/Seed.tscn")

func release_seeds(release_position, amount):
	for _i in range(amount):
		var seed_instance = seed_scene.instance()
		seed_instance.position = release_position
		add_child(seed_instance)



func end_game():
	# TODO Gameover
	#get_tree().paused = true
	#game_over = true
	pass

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




func _on_WindRight_button_down():
	$Cloud.accelerate_right()
	get_tree().call_group("dandelions", "blow_right")
	
func _on_WindLeft_button_down():
	$Cloud.accelerate_left()
	get_tree().call_group("dandelions", "blow_left")


func _on_Wind_button_up():
	get_tree().call_group("dandelions", "stop_blowing")
	$Cloud.stop_accelerating()


func _on_TimelimitTimer_timeout():
	end_game()
	pass # Replace with function body.
