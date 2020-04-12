extends Area2D


var sun = 0
var rain = 0


var active = false setget set_active

func set_active(new_active):
	
	$Rainometer.visible = new_active
	$Sunometer.visible = new_active
	
	active = new_active

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var collider = $RayCast2D.get_collider()
	
	if collider is Cloud and rain <= 100:
		var cloud = collider as Cloud
		
		rain += cloud.rain_level * delta
	
	rain -= delta * 0.5
	
	
	
	$Rainometer.value = rain
	$Sunometer.value = sun
	
