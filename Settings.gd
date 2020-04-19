extends Node

var properties =  {
	"volume": {
		"type": "number",
		"default": 0.2,
		"min": 0,
		"max": 1,
		"step": 0.05,
		"set": "_set_volume"
	},
	"scrollspeed": {
		"type": "number",
		"default": 30,
		"min": 10,
		"max": 100,
		"step": 5,
	},
	"reset tutorials": {
		"not_persistent": true,
		"type": "button",
		"pressed": "_reset_tutorials"
	},
	"restore settings": {
		"not_persistent": true,
		"type": "button",
		"pressed": "restore_defaults"
	}
}



# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _enter_tree():
	var node_data
	var save_game = File.new()
	if save_game.file_exists("user://settings.json"):
		save_game.open("user://settings.json", File.READ)
		
		node_data = parse_json(save_game.get_line())
	else:
		print("no settings-file found, loading default values")
	
	if node_data == null:
		node_data = {}
	#print(node_data)
	for key in properties.keys():
		if properties[key].has("not_persistent") and properties[key]["not_persistent"] == true:
			pass
		else:
			if node_data.has(key):
				set_property(key, node_data[key])
			else:
				set_property(key, properties[key]["default"])


func _exit_tree():
	var settings_file = File.new()
	settings_file.open("user://settings.json", File.WRITE)
	
	var save_dict = {}
	
	for key in properties.keys():
		if properties[key].has("not_persistent") and properties[key]["not_persistent"] == true:
			pass
		else:
			save_dict[key] = properties[key]["value"]
	
	
	settings_file.store_line(to_json(save_dict))



func get_property(key):
	return properties[key]["value"]


func set_property(key, value):
	var dict = properties[key]
	# check if ok
	match dict["type"]:
		"number":
			if value < dict["min"] or value > dict["max"]:
				print("value not in range")
				properties[key]["value"] = properties[key]["default"]
				return
	
	if dict.has("set"):
		call(dict["set"], value)
	
	dict["value"] = value


func restore_defaults():
	print("restore defaults")
	for key in properties.keys():
		if properties[key].has("not_persistent") and properties[key]["not_persistent"] == true:
			pass
		else:
			set_property(key, properties[key]["default"])

func _set_volume(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value))

# reset all "dont show tutorial" states
func _reset_tutorials():
	
	for tutorials_node in get_tree().get_nodes_in_group("tutorials"):
		tutorials_node.dont_show_again = []
		
	var dir = Directory.new()
	dir.remove("user://dontshowtutorials.json")

