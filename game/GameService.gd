extends Node

var time_limit = null
var goal_count = null

var last_scene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func start_game():
	last_scene = get_tree().get_current_scene().filename
	
	get_tree().change_scene("res://game/Game.tscn")

func back():
	get_tree().change_scene(last_scene)
	last_scene = null

func reset():
	time_limit = null
	goal_count = null
