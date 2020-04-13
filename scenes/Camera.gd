extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var home_position
# Called when the node enters the scene tree for the first time.
func _ready():
	home_position = position
	pass # Replace with function body.


var current_node = null

func zoom_to(node):
	# check weakref, if wr.get_ref() is false, the object is already freed (deleted)
	var wr = weakref(current_node)
	if wr.get_ref():
		current_node.active = false
	
	$Tween.interpolate_property(self, "position", position, node.position, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "zoom", zoom, Vector2(0.25, 0.25), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	current_node = node
	node.active = true
	
func zoom_out():
	# check weakref, if wr.get_ref() is false, the object is already freed (deleted)
	var wr = weakref(current_node)
	if wr.get_ref():
		current_node.active = false
	
	
	$Tween.interpolate_property(self, "position", position, home_position, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "zoom", zoom, Vector2(.5, .5), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	
	current_node = null
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
