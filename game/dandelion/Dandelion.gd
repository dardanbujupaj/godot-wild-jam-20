extends Area2D
class_name Dandelion



var sun = 0
var rain = 0

var rain_oversaturated = false
var sun_oversaturated = false

const MAX_AGE_LOWER_LIMIT = 30
const MAX_AGE_UPPER_LIMIT = 120

var next_age_countdown = 0
var max_age = 0
var age = 0

var size = 1



var fertilized = false


var is_blowing_left = false
var is_blowing_right = false


var active = false setget set_active

func set_active(new_active):
	$Node2D/Rainometer.visible = new_active
	$Node2D/Sunometer.visible = new_active
	
	active = new_active

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("dandelions")
	
	randomize()
	set_active(false)
	max_age =  rand_range(MAX_AGE_LOWER_LIMIT, MAX_AGE_UPPER_LIMIT)
	next_age_countdown = max_age / 4
	
	
	$AudioStreamPlayer2D.play()


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
	
	
	# fill/drain sunometer
	if collider is Cloud or Shared.night:
		sun = max(sun - 5 * delta, 0)
	else:
		sun = min(sun + 5 * delta, 100)
	
	# update progress bars
	$Node2D/Rainometer.value = rain
	$Node2D/Sunometer.value = sun
	
	
	# set oversaturated flag for sun and rain
	if rain > 75:
		rain_oversaturated = true
	if sun > 75:
		sun_oversaturated = true
	
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
			get_parent().release_seeds(position + $flower.position, round(size / 20))
			
			queue_free()


func update_animations():
	
	if $stem.texture != get_stem_texture():
		$stem.texture = get_stem_texture()
	
	# leaves animation
	var animation = get_leaves_animation()
		
	if animation != $leaves.animation:
		$leaves.play(animation)
		var frame_count = $leaves.frames.get_frame_count(animation)
		if frame_count > 0:
			$leaves.frame = randi() % frame_count


func get_stem_texture():
	if rain_oversaturated and sun_oversaturated:
		return preload("res://game/dandelion/stem_brown.png")
	elif rain_oversaturated or sun_oversaturated:
		return preload("res://game/dandelion/stem_halfbrown.png")
	else:
		return preload("res://game/dandelion/stem_green.png")
		

func get_leaves_animation():
	var animation
	
	if size > 20:
		animation = "large_"
	else:
		animation =  "small_"
	
	if rain_oversaturated and sun_oversaturated:
		animation += "brown"
	elif rain_oversaturated or sun_oversaturated:
		animation += "halfbrown"
	else:
		animation += "green"
		
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


func fertilize():
	fertilized = true
	$flower/CPUParticles2D.emitting = true
