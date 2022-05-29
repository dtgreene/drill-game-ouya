extends Node2D

const GroundExplosion = preload("res://scenes/boss/GroundExplosion.tscn")

var boss_ref = null

var explosions_created = 0
var time_elapsed = 0

func _ready():
	set_process(true)
	
	get_node("DirtParticles").set_emitting(true)
	boss_ref = weakref(get_node("/root/World/Underworld/Boss"))

func _process(delta):
	time_elapsed += delta
	if time_elapsed > 0.2:
		if explosions_created < 5:
			time_elapsed = 0
			explosions_created += 1
			add_explosions()
		# time elapsed since the last explosions were created
		elif time_elapsed > 1.25:
			queue_free()

func add_explosions():
	var boss = boss_ref.get_ref()
	if boss != null:
		boss.play_effect("ground_explosion")
	
	var position = Vector2()

	var used_instance
	used_instance = GroundExplosion.instance()
	used_instance.set_pos(Vector2(position.x - explosions_created * 32, position.y))
	add_child(used_instance)
	
	used_instance = GroundExplosion.instance()
	used_instance.set_pos(Vector2(position.x + explosions_created * 32, position.y))
	add_child(used_instance)

