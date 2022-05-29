extends "res://scripts/ui_screen.gd"

const TitleTexture = preload("res://assets/images/title.png")
const WorldScene = preload("res://scenes/world/World.tscn")
const GlobalValues = preload("res://scripts/global_values.gd")

const animation_speed = PI

enum Screens {
	MAIN,
	LOAD
}

var screen = Screens.MAIN
var released = false
var sin_value = 0
var selector_index = 0
var save_slots = []

func _ready():
	set_process(true)
	save_slots = GlobalValues.get_save_slots()
	
	Globals.set("load_slot", -1)
	
	# load settings
	var settings = File.new()
	if settings.file_exists("user://settings.save"):
		settings.open("user://settings.save", File.READ)
		var current_line = {}
		current_line.parse_json(settings.get_line())
		
		if current_line.has("music_volume"):
			AudioServer.set_stream_global_volume_scale(current_line.music_volume)
		if current_line.has("fx_volume"):
			AudioServer.set_fx_global_volume_scale(current_line.fx_volume)
		
		settings.close()
	else:
		AudioServer.set_stream_global_volume_scale(0.5)
		AudioServer.set_fx_global_volume_scale(0.8)
	
	get_node("/root/Start/StartMusic").play()

func _draw():
	draw_rect(Rect2(Vector2(0, 0), Vector2(320, 240)), Color(0, 0, 0))
	
	var title_size = Vector2(32, 32)
	var sin_value_current = sin_value
	for i in range(5):
		draw_texture_rect_region(TitleTexture, Rect2(Vector2(40 + i * 24, 64 + sin(sin_value_current) * 4), title_size), Rect2(Vector2(i * 32, 0), title_size))
		sin_value_current += 0.4
	
	for i in range(4):
		draw_texture_rect_region(TitleTexture, Rect2(Vector2(184 + i * 24, 64 + sin(sin_value_current) * 4), title_size), Rect2(Vector2(160 + i * 32, 0), title_size))
		sin_value_current += 0.4
	
	draw_rect(Rect2(Vector2(80, 136 + 16 * selector_index), Vector2(160, 16)), GlobalValues.ui_secondary)

	if screen == Screens.MAIN:
		draw_string(M5X7, Vector2(84, 148), "New Game")
		draw_line(Vector2(80, 152), Vector2(240, 152), Color(1, 1, 1))
		draw_string(M5X7, Vector2(84, 164), "Load Game")
		draw_line(Vector2(80, 168), Vector2(240, 168), Color(1, 1, 1))
		
		draw_icon_string(0, Vector2(299, 219), "Select", -34)
	elif screen == Screens.LOAD:
		
		draw_string(M5X7, Vector2(84, 132), "Slot")
		draw_string(M5X7, Vector2(204, 132), "Saved")
		draw_line(Vector2(80, 136), Vector2(240, 136), Color(1, 1, 1), 4)
		
		var i = 0
		while i < 3:
			var y = 148 + i * 16
			draw_string(M5X7, Vector2(84, y), "Slot " + str(i))
			draw_string(M5X7, Vector2(204, y), str(save_slots[i]))
			draw_line(Vector2(80, y + 4), Vector2(240, y + 4), Color(1, 1, 1))
			i += 1
		
		draw_icon_string(0, Vector2(244, 219), "Select", -34)
		draw_icon_string(1, Vector2(299, 219), "Close", -30)

func _process(delta):
	sin_value += animation_speed * delta
	update()
	
	if Input.is_action_pressed("ui_up"):
		if released:
			increment_selector(-1)
			released = false
	elif Input.is_action_pressed("ui_down"):
		if released:
			increment_selector(1)
			released = false
	elif Input.is_action_pressed("ui_cancel"):
		if released:
			if screen == Screens.LOAD:
				screen = Screens.MAIN
				selector_index = 0
				
				ui_effects_player.play("ui_cancel")
				update()
			released = false
	elif Input.is_action_pressed("ui_accept"):
		if released:
			if screen == Screens.MAIN:
				if selector_index == 0:
					get_tree().change_scene("res://scenes/world/World.tscn")
				elif selector_index == 1:
					screen = Screens.LOAD
					selector_index = 0
					
					ui_effects_player.play("ui_select")
					update()
			elif screen == Screens.LOAD:
				var name = "user://save" + str(selector_index) + ".save"
				var save = File.new()
				if !save.file_exists(name):
					ui_effects_player.play("ui_deny")
				else:
					Globals.set("load_slot", selector_index)
					get_tree().change_scene("res://scenes/world/World.tscn")
			released = false
	else:
		released = true

func increment_selector(amount):
	ui_effects_player.play("ui_hover")
	selector_index += amount
	
	var selector_index_max = 0
	if screen == Screens.MAIN:
		selector_index_max = 2
	elif screen == Screens.LOAD:
		selector_index_max = 3
		
	if selector_index < 0:
		selector_index = selector_index_max - 1
	elif selector_index >= selector_index_max:
		selector_index = 0
	update()