extends KinematicBody2D

class_name Cloud


const SPEED = 200

var velocity = Vector2()

var anger = 1


var rain_phase = "none"


onready var rain_levels = {
	"none": {
		"amount": 0,
		"particles": [],
		"increase": "mild",
		"decrease": null
	},
	"mild": {
		"amount": 2,
		"particles": [$ParticlesMild],
		"increase": "strong",
		"decrease": "none"
	},
	"strong": {
		"amount": 5,
		"particles": [$ParticlesStrong],
		"increase": null,
		"decrease": "mild"
	},
	"catsdogs": {
		"amount": 20,
		"particles": [
			$ParticlesCat1,
			$ParticlesCat2,
			$ParticlesDog1
		],
		"increase": null,
		"decrease": "strong"
	}
	
}



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	rain_phase = "none"



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if randi() % 500 == 0:
		if rain_levels[rain_phase]["decrease"] != null:
			change_rain_level(rain_levels[rain_phase]["decrease"])
			
	if randi() % 1000 == 0:
		if anger > 1:
			anger -=1
			
	$cloud.animation = str(anger)


func _physics_process(delta):
	position += velocity * delta * SPEED
	
	velocity *= .99
	

func _on_Cloud_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		if anger < 5:
			anger += 1
		
		if anger == 5:
			change_rain_level("catsdogs")
		else:
			if rain_levels[rain_phase]["increase"] != null:
				change_rain_level(rain_levels[rain_phase]["increase"])
			
			
		
			
		
		
		




func change_rain_level(to):
	for particle in rain_levels[rain_phase]["particles"]:
		
		particle.emitting = false
		
	for particle in rain_levels[to]["particles"]:
		
		particle.emitting = true
		
	rain_phase = to



func get_rain_amount():
	return rain_levels[rain_phase]["amount"]
