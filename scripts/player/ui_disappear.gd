extends Label

var decay = 0
var decay_length = 5
var suffix = ""
var prefix = ""

func _ready():
	set_hidden(true)

func update_value(value, color = null):
	if color != null:
		add_color_override("font_color", color)

	set_text(prefix + str(value) + suffix)
	set_hidden(false)
	set_process(true)
	decay = decay_length

func _process(delta):
	if decay > 0:
		decay -= delta
		if decay < 0.01:
			set_hidden(true)
			set_process(false)