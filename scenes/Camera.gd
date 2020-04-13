extends Camera2D


const SCROLL_SPEED = 200

# position to get back to when zooming out
var home_position


# Called when the node enters the scene tree for the first time.
func _ready():
	home_position = position


func _process(delta):
	print(get_local_mouse_position())
	print(get_viewport().size * zoom)
	if (get_local_mouse_position().x > get_viewport().size.x * zoom.x / 2 - 20 or
			Input.is_action_pressed("ui_right")):
		position.x += SCROLL_SPEED * delta
		home_position.x += SCROLL_SPEED * delta
		

	if (get_local_mouse_position().x < -get_viewport().size.x * zoom.x / 2 + 20 or
		Input.is_action_pressed("ui_left")):
		position.x -= SCROLL_SPEED * delta
		home_position.x -= SCROLL_SPEED * delta

var current_node

func zoom_to(node):
	print("zoom in")
	print(current_node)
	if current_node == null:
		print("set home position")
		# remember zooomed out position
		home_position = position
	else:
		# check weakref, if wr.get_ref() is false, the object is already freed (deleted)
		var wr = weakref(current_node)
		if wr.get_ref():
			# old node inactive
			current_node.active = false
	
	$Tween.interpolate_property(self, "position", position, node.position, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "zoom", zoom, Vector2(0.25, 0.25), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	
	current_node = node
	
	# set node active
	node.active = true
	
func zoom_out():
	print("zoom out")
	# check weakref, if wr.get_ref() is false, the object is already freed (deleted)
	var wr = weakref(current_node)
	if wr.get_ref():
		# set old node inactive
		current_node.active = false
	
	
	$Tween.interpolate_property(self, "position", position, home_position, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "zoom", zoom, Vector2(.5, .5), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	
	current_node = null
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
