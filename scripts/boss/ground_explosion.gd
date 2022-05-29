extends Area2D

onready var sprite = get_node("Sprite")

var boss_ref = null

func _ready():
	sprite.connect("finished", self, "finished")
	connect("area_enter", self, "area_enter")
	
	sprite.play("default")
	
	boss_ref = weakref(get_node("/root/World/Underworld/Boss"))

func finished():
	queue_free()

func area_enter(body):
	if body.has_meta("is_player"):
		var boss = boss_ref.get_ref()
		if boss != null:
			boss.damage_player(16)