extends Node

enum Screen {WALL_LIST, PROBLEM_LIST, CONFIG, WALL_VIEW, PROBLEM_VIEW, WALL_EDIT, PROBLEM_EDIT}

var last_data
var screen_scene: String	
var current_scene = null


func _ready() -> void:
	print("Starting...")
	load_screen(Screen.PROBLEM_LIST, null)

func load_screen(s: Screen, data):
	_deferred_load_screen.call_deferred(s, data)

func _deferred_load_screen(s: Screen, data):
	match (s):
		Screen.WALL_LIST: 
			screen_scene = ""
		Screen.PROBLEM_LIST:
			screen_scene = "res://screens/problem_list.tscn"
		Screen.PROBLEM_VIEW:
			screen_scene = "res://screens/problem_view.tscn"
		_:
			screen_scene = ""
	
	# remove all children
	var GUI = get_tree().root.get_child(-1)
	print ("Root: ", GUI)
	for c in GUI.get_children():
		GUI.remove_child(c)
		c.queue_free()
		print ("Removed: ", c)
	
	# load the scene and add it as new children
	var scene = load(screen_scene).instantiate()
	if data != null:
		scene.loadData(data)
	GUI.add_child(scene)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene.
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
