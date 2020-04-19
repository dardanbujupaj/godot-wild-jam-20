extends Bug


func _on_Bee_animation_finished():
	if $AnimatedSprite.animation == "sit":
		if target is Dandelion:
			target.fertilize()
