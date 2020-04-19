extends MarginContainer

var tutorial_hints = {
	"move_cloud": {
		"text": """Use the two wind buttons to generate wind.
		The wind will move it left or right."""
	},
	"move_bug": {
		"text": """Hover your pointer over the bug to make it move away."""
	},
	"make_rain": {
		"text": """Click the cloud to make it rain.
		But done make the cloud angry by clicking to often..."""
	}
}

var dont_show_again = []


# Called when the node enters the scene tree for the first time.
func _ready():
	show_tutorial("move_cloud")
	show_tutorial("move_bug")
	show_tutorial("make_rain")
	
	
	add_to_group("tutorials")
	
	pass


func _process(delta):
	if Input.is_key_pressed(KEY_A):
		show_tutorial("move_cloud")


func _enter_tree():
	var node_data
	var save_game = File.new()
	if save_game.file_exists("user://dontshowtutorials.json"):
		save_game.open("user://dontshowtutorials.json", File.READ)
		
		node_data = parse_json(save_game.get_line())
	else:
		return
	
	dont_show_again = node_data
	

func _exit_tree():
	var settings_file = File.new()
	settings_file.open("user://dontshowtutorials.json", File.WRITE)
	
	settings_file.store_line(to_json(dont_show_again))

func show_tutorial(key):
	if dont_show_again.has(key):
		return
	
	var tutorial_hint = tutorial_hints[key]
	
	var hint_instance = preload("res://game/tutorial/TutorialHint.tscn").instance()
	hint_instance.text = tutorial_hint["text"]
	
	hint_instance.connect("toggled_dont_show_again", self, "set_dont_show_again", [key])
	
	$VBoxContainer.add_child(hint_instance)


func set_dont_show_again(new_state, key):
	print("%s: %s" % [key, new_state])
	if new_state:
		if not dont_show_again.has(key):
			dont_show_again.append(key)
	else:
		if dont_show_again.has(key):
			dont_show_again.remove(key)
	
	
