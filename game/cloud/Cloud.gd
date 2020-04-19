extends KinematicBody2D

class_name Cloud


const MAX_SPEED = 100

var acceleration = Vector2()

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
		"amount": 3,
		"particles": [$ParticlesMild],
		"increase": "strong",
		"decrease": "none"
	},
	"strong": {
		"amount": 6,
		"particles": [$ParticlesStrong],
		"increase": null,
		"decrease": "mild"
	},
	"catsdogs": {
		"amount": 20,
		"particles": [
			$ParticlesCat1,
			$ParticlesCat2,
			$ParticlesDog1,
			$ParticlesDog2
		],
		"increase": null,
		"decrease": "strong"
	}
	
}



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	_on_AngerTimer_timeout()
	_on_RainTimer_timeout()
	
	rain_phase = "none"
	
	$RainSoundTimer.connect("timeout", self, "trigger_rain_sound")



func _physics_process(delta):
	if acceleration.length() > 0:
		velocity = acceleration * MAX_SPEED
	else:
		velocity *= .97
		
	position += velocity * delta
	
	

func _on_Cloud_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click") and event is InputEventMouseButton:

		if anger < 5:
			anger += 1
		
		$cloud.animation = str(anger)
		
		if anger == 5:
			change_rain_level("catsdogs")
			$ThunderPlayer.play()
		else:
			if rain_levels[rain_phase]["increase"] != null:
				change_rain_level(rain_levels[rain_phase]["increase"])
			




# activate and deactivate correct particles
func change_rain_level(to):
	for particle in rain_levels[rain_phase]["particles"]:
		
		particle.emitting = false
		
	for particle in rain_levels[to]["particles"]:
		
		particle.emitting = true
		
	rain_phase = to



func get_rain_amount():
	return rain_levels[rain_phase]["amount"]




# accelerate cloud when wind is blowing (called from Game.gd)
func accelerate_right():
	acceleration = Vector2(1, 0)
	
func accelerate_left():
	acceleration = Vector2(-1, 0)
	
func stop_accelerating():
	acceleration = Vector2(0, 0)




func _on_RainTimer_timeout():
	if rain_levels[rain_phase]["decrease"] != null:
		change_rain_level(rain_levels[rain_phase]["decrease"])
		
	$RainTimer.start(rand_range(4, 10))


 # decrease anger
func _on_AngerTimer_timeout():
	if anger > 1:
		anger -=1
		
	$cloud.animation = str(anger)
	
	$AngerTimer.start(rand_range(4, 10))


# trigger random raindrop sound depending on rain amount
func trigger_rain_sound():
	if get_rain_amount() > randi() % 10:
		if randi() % 2 == 0:
			$RainPlayer.stream = preload("res://game/sound/Sound_07_Drop1.wav")
		else:
			$RainPlayer.stream = preload("res://game/sound/Sound_09_Drop2.wav")
		$RainPlayer.play()
