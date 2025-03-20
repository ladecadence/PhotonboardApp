extends Node

enum Screen {WALL_LIST, PROBLEM_LIST, CONFIG, WALL_VIEW, PROBLEM_VIEW, WALL_EDIT, WALL_EDIT_HOLDS, PROBLEM_EDIT, TEST_WALLWIDGET}

var last_data
var screen_scene: String	
var current_scene = null


func _ready() -> void:
	# Copy wall image to user dir. JUST FOR TESTS. TODO remove this
	var img_texture_path := "res://images/wall0001.jpg"
	var img_texture := load(img_texture_path)
	var image = img_texture.get_image()
	image.save_jpg("user://wall01.jpg")
	
	
	# Initial screen
	load_screen(Screen.PROBLEM_LIST, null)

func load_screen(s: Screen, data):
	# calls the load function AFTER the current one finishes any running code
	_deferred_load_screen.call_deferred(s, data)

func _deferred_load_screen(s: Screen, data):
	# main screen router
	match (s):
		Screen.WALL_LIST: 
			screen_scene = ""
		Screen.PROBLEM_LIST:
			screen_scene = "res://screens/problem_list.tscn"
		Screen.PROBLEM_VIEW:
			screen_scene = "res://screens/problem_view.tscn"
		Screen.WALL_EDIT:
			screen_scene = "res://screens/wall_new.tscn"
		Screen.WALL_EDIT_HOLDS:
			screen_scene = "res://screens/wall_new_2.tscn"
		Screen.TEST_WALLWIDGET: # TODO: remove when finished
			screen_scene = "res://components/wall_widget.tscn"
		_:
			screen_scene = ""
	
	# remove all children from main node
	var GUI = get_tree().root.get_child(-1) # -1 = last root->GUI <---
	
	for c in GUI.get_children():
		GUI.remove_child(c)
		c.queue_free()
		print ("Removed: ", c)
	
	# load the scene and add it as new children of main node
	var scene = load(screen_scene).instantiate()
	# if we are passing some data, try to load it (the scene should have a loadData method...)
	if data != null and scene.has_method("loadData"):
		scene.loadData(data)
	GUI.add_child(scene)

func get_uuid_v4():
	const BYTE_MASK: int = 0b11111111
	# 16 random bytes with the bytes on index 6 and 8 modified
	var b = [
	randi() & BYTE_MASK, randi() & BYTE_MASK, randi() & BYTE_MASK, randi() & BYTE_MASK,
	randi() & BYTE_MASK, randi() & BYTE_MASK, ((randi() & BYTE_MASK) & 0x0f) | 0x40, randi() & BYTE_MASK,
	((randi() & BYTE_MASK) & 0x3f) | 0x80, randi() & BYTE_MASK, randi() & BYTE_MASK, randi() & BYTE_MASK,
	randi() & BYTE_MASK, randi() & BYTE_MASK, randi() & BYTE_MASK, randi() & BYTE_MASK,
	]

	return '%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x' % [
	# low
	b[0], b[1], b[2], b[3],
	# mid
	b[4], b[5],
	# hi
	b[6], b[7],
	# clock
	b[8], b[9],
	# clock
	b[10], b[11], b[12], b[13], b[14], b[15]
  ]
