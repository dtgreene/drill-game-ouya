extends Node2D

const move_speed = 256

onready var terrain = get_node("/root/World/Terrain")
onready var terrain_background = terrain.get_node("/root/World/Terrain/Background")
onready var label = get_node("CanvasLayer/Label")

func _ready():
	set_process(true)

func _process(delta):
	var right_pressed = Input.is_action_pressed("move_right")
	var left_pressed = Input.is_action_pressed("move_left")
	var up_pressed = Input.is_action_pressed("move_up")
	var down_pressed = Input.is_action_pressed("move_down")
	
	var player_pos = get_pos()
	if right_pressed:
		player_pos = Vector2(player_pos.x + move_speed * delta, player_pos.y)
	if left_pressed:
		player_pos = Vector2(player_pos.x - move_speed * delta, player_pos.y)
	if up_pressed:
		player_pos = Vector2(player_pos.x, player_pos.y - move_speed * delta)
	if down_pressed:
		player_pos = Vector2(player_pos.x, player_pos.y + move_speed * delta)
	
	set_pos(player_pos)
	
	# update terrain background
	terrain_background.update_y(floor(player_pos.y))
	
	# update terrain chunks
	terrain.update_chunks(player_pos)
	
	label.set_text(str(floor(player_pos.y / 32 * 12.5)) + "ft")
