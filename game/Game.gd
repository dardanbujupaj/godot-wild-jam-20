extends Node2D

onready var selection_helper = $SelectionHelper

enum {
	MODE_FREE,
	MODE_TIMELIMIT,
	MODE_GOAL,
	MODE_MISSION,
}

var game_mode = MODE_FREE

# Called when the node enters the scene tree for the first time.
func _ready():
	match game_mode:
		MODE_FREE:
			pass
		MODE_TIMELIMIT:
			$TimelimitTimer.start(120)
		MODE_GOAL:
			pass
		MODE_MISSION:
			$TimelimitTimer.start(120)
	
	# place starting dandelions
	var start_dandelion = add_dandelion(Vector2(0, 0))
	add_dandelion(Vector2(200, 0))


func _input(event):
	# open overlay menu when "escape" is pressed
	if Input.is_action_just_pressed("exit"):
		_popup_overlay_menu()


func _unhandled_input(event):
	if Input.is_action_just_pressed("click"):
		var zoom_out = true
		
		for node in selection_helper.get_overlapping_areas():
			if node is Dandelion:
				zoom_out = false
				$Camera.zoom_to(node)
				break
		
		if zoom_out:
			$Camera.zoom_out()


func _process(delta):
	# update selection helper
	selection_helper.position = get_global_mouse_position()
	
	$UI/DandelionCounter.text = str(len(get_tree().get_nodes_in_group("dandelions")))
	


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
	#for _i in range(amount):
	var seed_instance = seed_scene.instance()
	seed_instance.position = release_position
	add_child(seed_instance)


# pause and unpause game depending ond overlay menu
func _on_OverlayMenu_about_to_show():
	get_tree().paused = true


func _on_OverlayMenu_popup_hide():
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
