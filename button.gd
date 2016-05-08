# Defuser by Alket & Fitim - MIT License
extends Button

var x = 0
var y = 0
var shift = false
var flag = false

func _ready():
	set_name("button_"+str(y)+"_"+str(x))

func _on_Button_input_event( ev ):
	if ev.type == 3 and ev.button_index == 1 and not is_disabled() and not flag and not ev.is_echo() and ev.is_pressed():
		var clicks = get_node("/root/world").clicks
		get_node("/root/world").clicks += 1
		if get_node("/root/world").grid[y][x] != 0:
			set_text(str(get_node("/root/world").grid[y][x]))
		if clicks == 0:
			get_node("/root/world").generate(y,x)
			get_node("/root/world").expand(y,x)
		if get_node("/root/world").grid[y][x] == 0:
			get_node("/root/world").expand(y,x)
		set_disabled(true)
	
	if ev.type == 3 and ev.button_index == 2 and not is_disabled() and not ev.is_echo() and ev.is_pressed():
		flag = !flag
		if flag:
			set_text("@")
		else:
			set_text("")