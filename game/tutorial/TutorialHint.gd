tool
extends PanelContainer
class_name TutorialHint

signal toggled_dont_show_again

export var text: String setget set_text




# Called when the node enters the scene tree for the first time.
func _ready():
	set_text(text)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_text(new_value):
	text = new_value
	if $MarginContainer/VBoxContainer/RichTextLabel != null:
		$MarginContainer/VBoxContainer/RichTextLabel.text = new_value


func _on_CheckBox_toggled(button_pressed):
	emit_signal("toggled_dont_show_again", button_pressed)


func _on_Close_pressed():
	queue_free()
