extends Node2D

const opacity_max = 0.8

var opacity = 0

func _ready():
	set_hidden(true)

func _draw():
	draw_rect(Rect2(Vector2(0, 0), Vector2(320, 240)), Color(0, 0, 0, opacity))

func _process(delta):
	if opacity < opacity_max:
		opacity += 2 * delta
		update()
	else:
		set_process(false)

func fadeIn():
	set_hidden(false)
	set_process(true)
	
	opacity = 0

func hide():
	set_hidden(true)