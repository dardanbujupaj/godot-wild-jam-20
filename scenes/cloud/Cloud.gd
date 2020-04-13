extends KinematicBody2D

class_name Cloud


const SPEED = 100
var velocity = Vector2()

var rain_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position += velocity * delta * SPEED
	
	velocity *= .99
	


func _on_Cloud_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		
		if randi() % 5 == 0:
			$cloud.play("furious")
		else:
			$cloud.play("happy")
		
		
		
		if !$ParticlesMild.emitting and !$ParticlesStrong.emitting:
			$ParticlesMild.emitting = true
			rain_level = 2
		elif $ParticlesMild.emitting:
			$ParticlesMild.emitting = false
			$ParticlesStrong.emitting = true
			rain_level = 5
		else:
			$ParticlesStrong.emitting = false
			rain_level = 0
			
		
