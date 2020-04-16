extends Node

var time_limit = null
var goal_count = null



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func start_game():
	get_tree().change_scene("res://game/Game.tscn")
	


func reset():
	time_limit = null
	goal_count = null
