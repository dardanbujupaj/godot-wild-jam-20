extends CenterContainer

const missions = [
	{
		"dandelion_count": 2,
		"time_limit": 180
	},
	{
		"dandelion_count": 10,
		"time_limit": 240
	},
	{
		"dandelion_count": 20,
		"time_limit": 240
	}
]

var current_mission_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	load_mission(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_mission(index):
	GameService.reset()
	current_mission_index = index
	
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Title.text = "Mission #%d" % (index + 1)
	
	for goal in $PanelContainer/MarginContainer/VBoxContainer/Errands.get_children():
		goal.queue_free()
	
	
	var mission = missions[index]
	
	if mission.has("dandelion_count"):
		add_goal("plant %d dandelions" % mission["dandelion_count"])
		GameService.goal_count = mission["dandelion_count"]
		
	if mission.has("time_limit"):
		add_goal("Timelimit: %d" % mission["time_limit"])
		GameService.time_limit = mission["time_limit"]
		
	
	
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Previous.disabled = current_mission_index <= 0
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Next.disabled = current_mission_index >= len(missions) - 1


func add_goal(goal):
	
	var label = Label.new()
	label.text = "o " + goal
	$PanelContainer/MarginContainer/VBoxContainer/Errands.add_child(label)
	


func _on_Start_pressed():
	GameService.start_game()
	pass # Replace with function body.


func _on_Previous_pressed():
	load_mission(current_mission_index - 1)
	pass # Replace with function body.


func _on_Next_pressed():
	load_mission(current_mission_index + 1)
	pass # Replace with function body.
