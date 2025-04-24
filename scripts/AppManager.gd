extends Node

# definitions

enum Screen {WALL_LIST, PROBLEM_LIST, CONFIG, WALL_VIEW, PROBLEM_VIEW, WALL_EDIT, WALL_EDIT_HOLDS, PROBLEM_EDIT, PROBLEM_EDIT_HOLDS, PROBLEM_FILTER, TEST_WALLWIDGET}

# public attributes

var config: Config = Config.new("user://config.json")
var current_scene = null
var filter_problem: ProblemFilter = ProblemFilter.new()
var screen_scene: String

var data_source: Config.DataSource:
	get: return config.data_source
	set(source):
		config.data_source = source
		if source == Config.DataSource.LOCAL:
			Database.data_provider = CachedDataProvider.new(SQLiteDataProvider.new("user://database.sqlite"))
		elif source == Config.DataSource.CLOUD:
			#const BASE_URL := "https://photonboard.ladecadence.net/api"
			Database.data_provider = CachedDataProvider.new(HttpDataProvider.new(config.cloud_url, config.cloud_user, config.cloud_password, Database))
		else:
			push_error("invalid data source provided")

# public methods

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

func load_screen(s: Screen, data):
	# calls the load function AFTER the current one finishes any running code
	_deferred_load_screen.call_deferred(s, data)

func update_data_source() -> void:
	if Config.DataSource.LOCAL == config.data_source:
		Database.data_provider = CachedDataProvider.new(SQLiteDataProvider.new("user://database.sqlite"))
	elif Config.DataSource.CLOUD == config.data_source:
		Database.data_provider = CachedDataProvider.new(HttpDataProvider.new(config.cloud_url, config.cloud_user, config.cloud_password, Database))
	else:
		push_error("invalid data source provided")

# private methods

func _deferred_load_screen(s: Screen, data):
	# main screen router
	match (s):
		Screen.CONFIG:
			screen_scene = "res://screens/config.tscn"
		Screen.WALL_LIST: 
			screen_scene = "res://screens/wall_list.tscn"
		Screen.PROBLEM_LIST:
			screen_scene = "res://screens/problem_list.tscn"
		Screen.PROBLEM_VIEW:
			screen_scene = "res://screens/problem_view.tscn"
		Screen.PROBLEM_EDIT:
			screen_scene = "res://screens/problem_new.tscn"
		Screen.PROBLEM_EDIT_HOLDS:
			screen_scene = "res://screens/problem_new_2.tscn"	
		Screen.PROBLEM_FILTER:
			screen_scene = "res://screens/filter_problem_screen.tscn"
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
	if data != null and scene.has_method("load_data"):
		scene.load_data(data)
	GUI.add_child(scene)

func _ready() -> void:
	config.load()

	# If we don't have a valid data provider after loading the config
	# then set it up to the current default value
	if not Database.data_provider:
		update_data_source()

	# Android system bar
	SystemBar.set_status_bar_color("#262338")
	SystemBar.set_navigation_bar_color("#262338")
	# Initial screen
	load_screen(Screen.PROBLEM_LIST, null)
