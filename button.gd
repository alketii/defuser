# Defuser by Alket & Fitim - MIT License
extends Node2D

var x = 0
var y = 0
var shift = false
var flag = false
var opened = false

func _ready():
	set_name("button_"+str(y)+"_"+str(x))
func _on_TextureButton_input_event( ev ):
	if ev.type == 3 and ev.button_index == 1 and not opened and not flag and not ev.is_echo() and ev.is_pressed():
		opened = true
		var clicks = get_node("/root/world").clicks
		get_node("/root/world").clicks += 1
		if get_node("/root/world").grid[y][x] != -1:
			get_node("sprites").set_frame(get_node("/root/world").grid[y][x]+3)
			get_node("/root/world").opened += 1
			get_node("/root/world").check_win()
		else:
			get_node("/root/world").game_over()
		if clicks == 0:
			get_node("/root/world").generate(y,x)
			get_node("/root/world").expand(y,x)
		if get_node("/root/world").grid[y][x] == 0:
			get_node("/root/world").expand(y,x)
	
	if ev.type == 3 and ev.button_index == 2 and not opened and not ev.is_echo() and ev.is_pressed():
		flag = !flag
		if flag:
			get_node("sprites").set_frame(1)
			get_node("/root/world/hud/mines_left").set_text(str(int(get_node("/root/world/hud/mines_left").get_text())-1))
		else:
			get_node("sprites").set_frame(0)
			get_node("/root/world/hud/mines_left").set_text(str(int(get_node("/root/world/hud/mines_left").get_text())+1))