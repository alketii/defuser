# Defuser by Alket & Fitim - MIT License
extends Node2D

var button = preload("res://button.tscn")
var grid_size = Vector2(10,10)
var level = 0
var mines_total = global.level * 5
var grid = []
var grid_total = 0
var clicks = 0
var mines = []
var game_over = false
var opened = 0

func _ready():
	if global.level == 10:
		global.level = 1
		get_tree().reload_current_scene()
	get_node("hud/restart").hide()
	OS.set_window_size(Vector2(grid_size.x*32,grid_size.y*32+32))
	OS.set_window_position(Vector2(OS.get_screen_size().x / 2 - grid_size.x*16, (OS.get_screen_size().y+32) / 2 - grid_size.y*16))
	get_tree().set_screen_stretch(2,2,Vector2(Vector2(grid_size.x*32,grid_size.y*32+32)))
	get_node("hud/mines_left").set_text(str(mines_total))
	get_node("hud/level").set_text(str(global.level))
	grid_total = grid_size.x * grid_size.y
	for y in range(grid_size.y):
		grid.append([])
		for x in range(grid_size.x):
			grid[y].append(0)
			var button_new = button.instance()
			button_new.x = x
			button_new.y = y
			button_new.set_pos(Vector2(x*32,(y*32)+32))
			add_child(button_new)

func generate(x,y):
	randomize()
	var mines_temp = [[x,y],[x,y-1],[x,y+1],[x-1,y],[x+1,y],[x-1,y-1],[x-1,y+1],[x+1,y-1],[x+1,y+1]]
	var mines_assigned = mines_total
	var mine_similar = false
	var rand_x = 0
	var rand_y = 0
	while mines_assigned > 0:
		rand_x = randi() % int(grid_size.x)
		rand_y = randi() % int(grid_size.y)
		mine_similar = false
		for mine in mines_temp:
			if mine[0] == rand_y and mine[1] == rand_x:
				mine_similar = true
		if not mine_similar:
			mines_temp.append([rand_x,rand_y])
			grid[rand_y][rand_x] = -1
			mines_assigned -= 1
	
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			if grid[y][x] == -1:
				if x > 0 and y > 0:
					is_mine(y-1,x-1) # top left
				if y > 0:
					is_mine(y-1,x) # top center
				if x < grid_size.x-1 and y > 0:
					is_mine(y-1,x+1) # top right
				if x > 0:
					is_mine(y,x-1) # middle left
				if x < grid_size.x-1:
					is_mine(y,x+1) # middle right
				if x > 0 and y < grid_size.y-1:
					is_mine(y+1,x-1) # bottom left
				if y < grid_size.y-1:
					is_mine(y+1,x) # bottom center
				if x < grid_size.x-1 and y < grid_size.y-1:
					is_mine(y+1,x+1) # bottom right

func is_mine(y,x):
	if grid[y][x] != -1:
		grid[y][x] += 1

func expand(y,x):
	if x > 0 and y > 0:
		cell_show(y-1,x-1) # top left
	if y > 0:
		cell_show(y-1,x) # top center
	if x < grid_size.x-1 and y > 0:
		cell_show(y-1,x+1) # top right
	if x > 0:
		cell_show(y,x-1) # middle left
	if x < grid_size.x-1:
		cell_show(y,x+1) # middle right
	if x > 0 and y < grid_size.y-1:
		cell_show(y+1,x-1) # bottom left
	if y < grid_size.y-1:
		cell_show(y+1,x) # bottom center
	if x < grid_size.x-1 and y < grid_size.y-1:
		cell_show(y+1,x+1) # bottom right

func cell_show(y,x):
	if not get_node("button_"+str(y)+"_"+str(x)).opened:
		get_node("button_"+str(y)+"_"+str(x)).opened = true
		get_node("button_"+str(y)+"_"+str(x)+"/sprites").set_frame(grid[y][x]+3)
		opened += 1
		get_node("/root/world").check_win()
		if grid[y][x] == 0:
			expand(y,x)

func _on_restart_pressed():
	if game_over:
		global.level = 1
	else:
		global.level += 1
	get_tree().reload_current_scene()
	
func game_over():
	game_over = true
	get_node("hud/restart").set_text("Restart")
	get_node("hud/restart").show()
	show_all()
	
func check_win():
	print(grid_total - opened)
	if grid_total - opened == mines_total and not game_over:
			get_node("hud/restart").set_text("Next")
			get_node("hud/restart").show()
			show_all()
			
func show_all():
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			get_node("button_"+str(y)+"_"+str(x)).opened = true
			get_node("button_"+str(y)+"_"+str(x)+"/sprites").set_frame(grid[y][x]+3)