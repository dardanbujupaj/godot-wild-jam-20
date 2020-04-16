extends Area2D


const SPEED = Vector2(0, -1) * 50

onready var sprite: AnimatedSprite = $AnimatedSprite

# used to make a smooth landing animation
onready var landing_tween: Tween = $LandingTween



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# where to fly next
var target: Node2D
var last_target: Node2D

# make the bug change its flight direction
var angular_velocity = 0



func _process(delta):
	if randi() % 50 == 0:
		
		# check weakref, if wr.get_ref() is false, the object is already freed (deleted)
		var wr = weakref(target)
		if wr.get_ref():
			var distance = target.position - position
			angular_velocity = Vector2(0, -1).rotated(rotation).angle_to(distance)
		else:
			# fly random
			if angular_velocity > 0:
				angular_velocity = -randf()
			else:
				angular_velocity = randf()
			
			# search new target
			find_target()
	
	

# finde a new target 
func find_target():
	var nodes = get_tree().get_nodes_in_group("dandelions")
	nodes.shuffle()
	
	for node in nodes:
		if node != last_target:
			target = node
			last_target = node
			break


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if sprite.animation == "fly":
		rotation += angular_velocity * delta
		
		position += SPEED.rotated(rotation) * delta


#take of from object
func take_off():
	target = null
	sprite.play("take_off")


# land on a object
func land_on(node: Node2D):
	# take off when object is deleted
	node.connect("tree_exiting", self, "take_off")
	
	
	# play landing animation
	sprite.play("land")
	
	# move bug onto the object
	landing_tween.interpolate_property(self, "position", position, node.position + Vector2(0, -16), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	landing_tween.interpolate_property(self, "rotation", rotation, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	landing_tween.start()


# change animation as soon as oneshot animations are finished
func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "take_off":
		sprite.play("fly")
	if sprite.animation == "land":
		sprite.play("sit")


# take off when mouse is moved over the bug
func _on_Bug_mouse_entered():
	if sprite.animation =="sit":
			take_off()

# land on dandelions
func _on_Bug_area_entered(area):
	if area == target:
		land_on(area)
