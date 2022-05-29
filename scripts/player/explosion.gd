extends AnimatedSprite

var delay = 0
onready var start_timer = get_node("Timer")

func _ready():
	connect("finished", self, "finished")
	if delay > 0:
		start_timer.set_wait_time(delay)
		start_timer.connect("timeout", self, "play_animation")
		start_timer.start()
		set_hidden(true)
	else:
		play("default")

func play_animation():
	set_hidden(false)
	play("default")

func finished():
	queue_free()