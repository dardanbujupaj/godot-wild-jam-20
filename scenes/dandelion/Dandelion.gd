extends Area2D
class_name Dandelion


var sun = 0
var rain = 0
var age = 0


var active = false setget set_active

func set_active(new_active):
	
	$Rainometer.visible = new_active
	$Sunometer.visible = new_active
	
	active = new_active

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey:
		var key_event = event as InputEventKey
		if key_event.pressed and not key_event.echo and key_event.scancode == KEY_S:
			release_seed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	age += delta
	
	var collider = $RayCast2D.get_collider()
	
	if collider is Cloud and rain <= 100:
		var cloud = collider as Cloud
		
		rain += cloud.rain_level * delta
	
	if rain > 0:
		rain -= delta * 0.5
	
	
	
	$Rainometer.value = rain
	$Sunometer.value = sun
	
	if age > 20:
		randomize()
		for i in randi() % 3:
			release_seed()
			queue_free()


func release_seed():
	var seed_node = preload("res://scenes/seed/Seed.tscn").instance()
	seed_node.position = position + Vector2(0, -60)
	get_parent().add_child(seed_node)
