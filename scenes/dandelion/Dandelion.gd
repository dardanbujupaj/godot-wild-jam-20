extends Area2D
class_name Dandelion



var sun = 0
var rain = 0

const MAX_AGE_LOWER_LIMIT = 30
const MAX_AGE_UPPER_LIMIT = 120

var next_age_countdown = 0
var max_age = 0
var age = 0

var size = 1

var blow_left = false
var blow_right = false


var active = false setget set_active

func set_active(new_active):
	
	$Rainometer.visible = new_active
	$Sunometer.visible = false #new_active
	
	active = new_active

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("dandelions")
	
	randomize()
	set_active(false)
	max_age =  rand_range(MAX_AGE_LOWER_LIMIT, MAX_AGE_UPPER_LIMIT)
	next_age_countdown = max_age / 4


func _input(event):
	
	# DEBUG: release seeds
	if event is InputEventKey:
		var key_event = event as InputEventKey
		if key_event.pressed and not key_event.echo and key_event.scancode == KEY_S:
			release_seed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# check for cloud
	var collider = $RayCast2D.get_collider()
	
	# fill rainometer
	if collider is Cloud and rain <= 100:
		var cloud = collider as Cloud
		
		rain += cloud.get_rain_amount() * delta
	
	if rain > 0:
		rain -= delta * 0.5
	
	
	# update progress bars
	$Rainometer.value = rain
	$Sunometer.value = sun
	
	
	
	# calculate grow rate and change size
	var grow_rate = .2
	# check rain bar
	if rain > 25 and rain < 75:
		grow_rate += 1
	#check sun bar
	if sun > 25 and sun < 75:
		grow_rate += 1
	#change size
	size += delta * grow_rate
	
	
	
	$stem.scale.y = -size
	$flower.position.y = -size
	
	if size > 20:
		$leaves.play("large_green")
	
	
	next_age_countdown -= delta
	
	if next_age_countdown < 0:
		age += 1
		
		next_age_countdown = max_age / 4
		
		if age < 4:
			var animation = "age_" + str(age)
			if blow_left:
				animation += "_left"
			elif blow_right:
				animation += "_right"
				
			$flower.play(animation)
		else:
			for i in range(round(size / 20)):
				release_seed()
			queue_free()


func release_seed():
	var seed_node = preload("res://scenes/seed/Seed.tscn").instance()
	seed_node.position = position + Vector2(0, -60)
	get_parent().add_child(seed_node)


func blow_left():
	$flower.play("age_" + str(age) + "_left")
	
	blow_left = true
	

func blow_right():
	$flower.play("age_" + str(age) + "_right")
	
	blow_right = true


func stop_blowing():
	$flower.play("age_" + str(age))
	blow_left = false
	blow_right = false
