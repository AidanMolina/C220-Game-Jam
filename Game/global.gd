extends Node

var time = 30
var level = 0

var level_list = [
	"res://UI/Main Menu.tscn", # 0
	"res://UI/Intro.tscn", #1
	"res://Levels/TestLevelA.tscn", # 2
	"res://Levels/TestLevelB.tscn", # 3
	"res://Levels/TestLevelC.tscn", #4
	"res://UI/Lose.tscn", #5
	"res://UI/Credits.tscn" #6
]

var level_list_alternate = [
	"res://UI/Main Menu.tscn", # 0
	"res://UI/Intro.tscn", #1
	"res://Levels/TestLevelA.tscn", # 2
	"res://Levels/TestLevelBAlternate.tscn", # 3
	"res://Levels/TestLevelCAlternate.tscn", #4
	"res://UI/Win Scene.tscn", #5
	"res://UI/Credits.tscn" #6
]

signal time_changed

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	if level == 1:
		time = 30
	

func _unhandled_input(event):
	if event.is_action_pressed("quit"): 
		var menu = get_node_or_null("/root/Game/UI/Menu")
		if menu != null:
			var p = get_tree().paused
			if p:
				menu.hide()
				get_tree().paused = false
			else:
				menu.show()
				get_tree().paused = true


func change_time():
	time -= 1
	if time <= 0:
		next_level()
	emit_signal("time_changed")
	
func next_level():
	level += 1
	if level < level_list.size() and level >= 0:
		time = 30
		get_tree().change_scene(level_list[level])
	if level >= level_list.size():
		level = 0
		get_tree().change_scene(level_list[level])

func next_level_alternate():
	level += 1
	if level < level_list_alternate.size() and level >= 0:
		time += 30
		get_tree().change_scene(level_list_alternate[level])
	if level >= level_list_alternate.size():
		level = 0
		get_tree().change_scene(level_list_alternate[level])
