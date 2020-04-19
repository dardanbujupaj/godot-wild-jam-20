extends Camera2D

const ZOOM_NEAR = .25
const ZOOM_FAR = .5

var camera_range = Constants.GAME_WIDTH / 2

# position to get back to when zooming out
var home_position


# Called when the node enters the scene tree for the first time.
func _ready():
	home_position = position

func _input(event):
	var scrollspeed = Settings.get_property("scrollspeed")
	var viewport_width = get_viewport_rect().size.x
	
		
	if event.is_action("scroll_left") and position.x + viewport_width / 2 * zoom.x < camera_range:
		position.x += scrollspeed
		
		set_home_position(home_position + Vector2(scrollspeed, 0))
		
	if event.is_action("scroll_right") and position.x - viewport_width / 2 * zoom.x > -camera_range:
		position.x -= scrollspeed
		
		set_home_position(home_position + Vector2(-scrollspeed, 0))
		
		
# check if 
func set_home_position(new_position):
	var viewport_width = get_viewport_rect().size.x
	
	if (new_position.x - viewport_width / 2 * ZOOM_FAR > -camera_range and
		new_position.x + viewport_width / 2 * ZOOM_FAR < camera_range):
		home_position = new_position
	
	
var current_node

func zoom_to(node):
	print("zoom to %s" % node)
	
	
	# check weakref, if wr.get_ref() is false, the object is already freed (deleted)
	var wr = weakref(current_node)
	if wr.get_ref() and current_node is Dandelion:
		# old node inactive
		current_node.active = false
	
	$Tween.interpolate_property(self, "position", position, node.position, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "zoom", zoom, Vector2(0.25, 0.25), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	
	current_node = node
	
	# set node active
	node.active = true
	
func zoom_out():
	# check weakref, if wr.get_ref() is false, the object is already freed (deleted)
	var wr = weakref(current_node)
	if wr.get_ref() and current_node is Dandelion:
		# set old node inactive
		current_node.active = false
	
	
	$Tween.interpolate_property(self, "position", position, home_position, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "zoom", zoom, Vector2(.5, .5), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	
	current_node = null
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

