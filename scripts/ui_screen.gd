extends Node2D

const M5X7 = preload("res://assets/fonts/m5x7.fnt")
const GlobalValues = preload("res://scripts/global_values.gd")

const icons = [
	preload("res://assets/images/icon_o.png"), 
	preload("res://assets/images/icon_a.png")
]

var ui_effects_player = null

signal pause_notification()
signal screen_toggle(open)

func _ready():
	if get_node("/root/").get_child(0).get_name() == "World":
		ui_effects_player = get_node("/root/World/UIEffects")
	else:
		ui_effects_player = get_node("/root/Start/UIEffects")

func draw_icon_string(icon_index, icon_position, string, x_offset):
	draw_texture(icons[icon_index], icon_position)
	draw_string(M5X7, Vector2(icon_position.x + x_offset, icon_position.y + 11), string)

