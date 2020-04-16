extends WindowDialog


var control_map = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for key in Settings.properties.keys():
		var dict = Settings.properties[key]
		var hbox = HBoxContainer.new()
		
		var label = Label.new()
		label.text = key
		label.rect_min_size.x = 100
		
		hbox.add_child(label)
		
		if dict["type"] == "number":
			
			var slider = HSlider.new()
			
			slider.min_value = dict["min"]
			slider.max_value = dict["max"]
			slider.step = dict["step"]
			slider.value = dict["value"]
			slider.rect_min_size.x = 100
			
			slider.connect("value_changed", self, "set_property", [key])
			
			control_map[key] = slider
			
			hbox.add_child(slider)
		
		
		$MarginContainer/VBoxContainer.add_child(hbox)
		
	$MarginContainer/VBoxContainer.move_child($MarginContainer/VBoxContainer/RestoreDefaults, $MarginContainer/VBoxContainer.get_child_count() - 1)
	
	set_as_minsize()


func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		hide()

func _load_properties():
	for key in control_map.keys():
		control_map[key].value = Settings.get_property(key)
	

func set_property(value, key):
	Settings.set_property(key, value)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RestoreDefaults_pressed():
	Settings.restore_defaults()
	_load_properties()
