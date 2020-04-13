extends Node2D

onready var selection_helper = $SelectionHelper


# Called when the node enters the scene tree for the first time.
func _ready():
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
	
	if Input.is_action_pressed("ui_left"):
		$Camera.position.x -= 1
	if Input.is_action_pressed("ui_right"):
		$Camera.position.x += 1
		
		
	


# open the overlay menu
func _popup_overlay_menu():
	$UI/OverlayMenu.popup_centered()


# add a new dandelion at position
func add_dandelion(position):
	var dandelion = preload("res://scenes/dandelion/Dandelion.tscn").instance()
	
	dandelion.position = position
	dandelion.connect("input_event", self, "_on_Dandelion_input_event", [dandelion])
	
	add_child(dandelion)
	return dandelion




# pause and unpause game depending ond overlay menu
func _on_OverlayMenu_about_to_show():
	get_tree().paused = true


func _on_OverlayMenu_popup_hide():
	get_tree().paused = false




func _on_WindRight_pressed():
	$Cloud.velocity = Vector2(1, 0)


func _on_WindLeft_pressed():
	$Cloud.velocity = Vector2(-1, 0)

