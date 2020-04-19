extends CenterContainer

const progress_filepath = "user://missions_progress.json"

const missions = [
	
	{
		"dandelion_count": 2,
		"time_limit": 180
	},
	{
		"dandelion_count": 5,
		"time_limit": 240,
		"bug": true
	},
	{
		"dandelion_count": 10,
		"time_limit": 240,
		"bug": true,
		"bee": true
	},
	{
		"goal_eastereggs": true,
		"bug": true,
		"bee": true
	},
	{
		"dandelion_count": 15,
		"time_limit": 240,
		"bug": true,
		"bee": true
	},
	{
		"dandelion_count": 20,
		"time_limit": 300,
		"bug": true,
		"bee": true
	},
	{
		"dandelion_count": 25,
		"time_limit": 300,
		"bug": true,
		"bee": true
	}
]

var missions_done = []

var current_mission_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameService.mission_index != null and GameService.mission_success:
		missions_done.append(GameService.mission_index)
		load_mission(GameService.mission_index)
	else:
		# TODO load first mission not done
		load_mission(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_mission(index):
	GameService.reset()
	current_mission_index = index
	
	var done = false
	for i in missions_done:
		if i == index:
			done = true
	
	$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Title.text = "Mission #%d" % (index + 1)
	
	for goal in $MarginContainer/MarginContainer/VBoxContainer/Errands.get_children():
		goal.queue_free()
	
	
	var mission = missions[index]
	
	if mission.has("dandelion_count"):
		add_goal("plant %d dandelions" % mission["dandelion_count"], done)
		GameService.goal_count = mission["dandelion_count"]
		
	if mission.has("time_limit"):
		add_goal("Timelimit: %d" % mission["time_limit"], done)
		GameService.time_limit = mission["time_limit"]
	
	if mission.has("goal_eastereggs"):
		add_goal("Find all 3 eastereggs", done)
		GameService.goal_eastereggs = true
		
	if mission.has("bug"):
		GameService.bug = true
	if mission.has("bee"):
		GameService.bee = true
	
	$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Previous.disabled = current_mission_index <= 0
	$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Next.disabled = current_mission_index >= len(missions) - 1


func add_goal(goal, done):
	var goal_instance = preload("res://game/tutorial/Goal.tscn").instance()
	goal_instance.text = goal
	goal_instance.done = done
	
	$MarginContainer/MarginContainer/VBoxContainer/Errands.add_child(goal_instance)
	

func _enter_tree():
	var node_data
	var save_game = File.new()
	if save_game.file_exists(progress_filepath):
		save_game.open(progress_filepath, File.READ)
		
		node_data = parse_json(save_game.get_line())
	else:
		return
	
	
	missions_done = node_data
	

func _exit_tree():
	var missions_file = File.new()
	missions_file.open(progress_filepath, File.WRITE)
	
	missions_file.store_line(to_json(missions_done))


func _on_Start_pressed():
	GameService.start_game()
	GameService.mission_index = current_mission_index
	pass # Replace with function body.


func _on_Previous_pressed():
	load_mission(current_mission_index - 1)
	pass # Replace with function body.


func _on_Next_pressed():
	load_mission(current_mission_index + 1)
	pass # Replace with function body.


func _on_Back_pressed():
	get_tree().change_scene("res://ui/titlescreen/TitleScreen.tscn")
