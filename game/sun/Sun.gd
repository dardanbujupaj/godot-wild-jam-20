extends Tween

const COLOR_DAY = Color(.37, .93, .92)
const COLOR_NIGHT = Color(0.007019, 0.007019, 0.179688)

func _process(delta):
	if tell() < 4 or tell() > 20:
		Shared.night = true
	else:
		Shared.night = false
# Called when the node enters the scene tree for the first time.
func _ready():
	interpolate_property($Path2D/PathFollow2D, "offset", 0, $Path2D.curve.get_baked_length(), 24)
	
	interpolate_method(VisualServer, "set_default_clear_color", COLOR_NIGHT, COLOR_DAY,  12, Tween.TRANS_LINEAR, Tween.EASE_IN)
	interpolate_method(VisualServer, "set_default_clear_color", COLOR_DAY, COLOR_NIGHT, 12, Tween.TRANS_LINEAR, Tween.EASE_IN, 12)
	seek(8)
	start()
	pass # Replace with function body.
	
	
