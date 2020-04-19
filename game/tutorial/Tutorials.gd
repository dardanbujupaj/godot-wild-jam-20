extends MarginContainer

var tutorial_hints = {
	"better_luck_this_time": {
		"text": """Seems like you ran out of dandelions.
		No Problem, here's a new one.
		Better luck this time!!!"""
	},
	"zoom_to_dandelion": {
		"text": "Click on a dandelion to zoom to it and show its details."
	},
	"dandelion_age": {
		"text": """The flower tells you about the age of the dandelion.
		Some Dandelions age faster, some slower.
		The higher it gets trough its lifetime, the more seeds it will release."""
	},
	"dandelion_sun": {
		"text": """The bar on the left side of the dandelion shows how many sun energy it has stored.
		It gains energy when it's day and no cloud is above it.'"""
	},
	"dandelion_rain": {
		"text": """The bar on the left side tells you how much water is store.
		Let the cloud rain to fill up the water bar."""
	},
	"zoom_out": {
		"text": """Click on a place where no dandelion grows to zoom out."""
	},
	"cloud_rain": {
		"text": """Click the cloud to make it rain.
		But done make the cloud angry by clicking too often..."""
	},
	"cloud_move": {
		"text": """Use the two wind buttons at the top of the screen to generate wind.
		The wind will move the cloud left or right."""
	},
	"move_bug": {
		"text": """Hover your pointer over the bug to make it move away."""
	}
}

var dont_show_again = []


# Called when the node enters the scene tree for the first time.
func _ready():
	
	add_to_group("tutorials")
	

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
	
	if tutorial_hints.has(key):
		if not is_tutorial_active(key):
			var tutorial_hint = tutorial_hints[key]
			
			var hint_instance = preload("res://game/tutorial/TutorialHint.tscn").instance()
			hint_instance.tutorial_key = key
			hint_instance.text = tutorial_hint["text"]
			
			hint_instance.connect("toggled_dont_show_again", self, "set_dont_show_again", [key])
			
			$VBoxContainer.add_child(hint_instance)
	
	else:
		print("Could not find tutorialkey: " + key)

func is_tutorial_active(key):
	for tutorial in $VBoxContainer.get_children():
		if tutorial.tutorial_key == key:
			return true
	
	return false

func set_dont_show_again(new_state, key):
	print("%s: %s" % [key, new_state])
	if new_state:
		if not dont_show_again.has(key):
			dont_show_again.append(key)
	else:
		if dont_show_again.has(key):
			dont_show_again.remove(key)
	
	
