extends KinematicBody2D



var velocity: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	velocity = Vector2(rand_range(-1, 1), rand_range(-1, 0)) * 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#velocity.x += rand_range(-1, 1)
	
	velocity.y += rand_range(-0.5, 1)
	
	position += velocity * delta
	
	
	rotation = velocity.x / 100
	
	if position.y > 0:
		spawn_dandelion()
	
	

func spawn_dandelion():
	get_parent().add_dandelion(position)
	
	queue_free()
