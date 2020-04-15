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

var is_blowing_left = false
var is_blowing_right = false


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
			get_parent().release_seeds(position + $flower.position, 1)


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
	
	#if size > 20:
	
	call_deferred("update_animations")
	
	
	next_age_countdown -= delta
	
	if next_age_countdown < 0:
		age += 1
		
		next_age_countdown = max_age / 4
		
		if age < 4:
			var animation = "age_" + str(age)
			if is_blowing_left:
				animation += "_left"
			elif is_blowing_right:
				animation += "_right"
				
			$flower.play(animation)
		else:
			get_parent().release_seeds($flower.position, round(size / 20))
			
			queue_free()


func update_animations():
	# leaves animation
	var animation
	
	if size > 20:
		animation = "large_green"
	else:
		animation =  "small_green"
		
	if is_blowing_left:
		animation += "_left"
	elif is_blowing_right:
		animation += "_right"
		
	if animation != $leaves.animation:
		$leaves.play(animation)
		var frame_count = $leaves.frames.get_frame_count(animation)
		if frame_count > 0:
			$leaves.frame = randi() % frame_count



func get_leaves_animation():
	var animation
	
	if size > 20:
		animation = "large_green"
	else:
		animation =  "small_green"
		
	if is_blowing_left:
		animation += "_left"
	elif is_blowing_right:
		animation += "_right"
		
	return animation

func blow_left():
	$flower.play("age_" + str(age) + "_left")
	$flower.frame = randi() % 4
	
	
	is_blowing_left = true



func blow_right():
	$flower.play("age_" + str(age) + "_right")
	$flower.frame = randi() % 4
	
	is_blowing_right = true


func stop_blowing():
	$flower.play("age_" + str(age))
	$flower.frame = randi() % 3
	
	
	is_blowing_left = false
	is_blowing_right = false
