extends Area2D
class_name Seed



var velocity: Vector2
var wind_acceleration = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	velocity = Vector2(rand_range(-2, 2), rand_range(-1, -.5)) * 100
	add_to_group("seeds")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#velocity.x += rand_range(-1, 1)
	
	velocity.y += 9.81 * 2 * delta
	
	position += (velocity) * delta
	
	
	rotation = velocity.x / 100
	
	if wind_acceleration.length() != 0 and velocity.length() < 100:
		
		velocity += wind_acceleration * delta
		
	elif velocity.x != 0:
		velocity.x -= velocity.x * delta
	
	
		
	if position.y > 0:
		if position.x > Constants.GAME_WIDTH / 2 or position.x < -Constants.GAME_WIDTH / 2:
			# seed landed outside game width
			queue_free()
			return 
			
		for area in get_overlapping_areas():
			# area already occupied
			queue_free()
			return
		
		spawn_dandelion()
	
	

func spawn_dandelion():
	get_parent().add_dandelion(position)
	
	queue_free()



func blow_left():
	wind_acceleration = Vector2(-50, 0)
	
func blow_right():
	wind_acceleration = Vector2(50, 0)

func stop_blowing():
	wind_acceleration = Vector2(0, 0)
