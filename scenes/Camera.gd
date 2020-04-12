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
	if current_node != null:
		current_node.active = false
	
	$Tween.interpolate_property(self, "position", position, node.position, 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "zoom", zoom, Vector2(0.5, 0.5), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	current_node = node
	node.active = true
	
func zoom_out():
	if current_node != null:
		current_node.active = false
	
	
	$Tween.interpolate_property(self, "position", position, home_position, 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "zoom", zoom, Vector2(1, 1), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	
	current_node = null
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
