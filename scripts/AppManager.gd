extends Node

enum Screen {WALL_LIST, PROBLEM_LIST, CONFIG, WALL_VIEW, PROBLEM_VIEW, WALL_EDIT, WALL_EDIT_HOLDS, PROBLEM_EDIT, TEST_WALLWIDGET}

var last_data
var screen_scene: String
var current_scene = null
var wall_ip: String = "127.0.0.1"


func _ready() -> void:
	# database
	if not Database.database_exists():
		Database.init_database()
		Database.create_test_data()
	
	Database.get_db_wall("1fddf17c-3ddf-4dc7-a3d0-e3ac3d9f8b05")
	load_config()
	
	# Initial screen
	load_screen(Screen.WALL_LIST, null)

func load_screen(s: Screen, data):
	# calls the load function AFTER the current one finishes any running code
	_deferred_load_screen.call_deferred(s, data)

func _deferred_load_screen(s: Screen, data):
	# main screen router
	match (s):
		Screen.CONFIG:
			screen_scene = "res://screens/Config.tscn"
		Screen.WALL_LIST: 
			screen_scene = "res://screens/wall_list.tscn"
		Screen.PROBLEM_LIST:
			screen_scene = "res://screens/problem_list.tscn"
		Screen.PROBLEM_VIEW:
			screen_scene = "res://screens/problem_view.tscn"
		Screen.PROBLEM_EDIT:
			screen_scene = "res://screens/problem_new.tscn"
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

func save_config():
	var data = {
		"wall_ip": wall_ip
	}
	var config_file = FileAccess.open("user://config.json", FileAccess.WRITE)
	var json_string = JSON.stringify(data)
	config_file.store_string(json_string)
	
func load_config():
	if not FileAccess.file_exists("user://config.json"):
		return # Error! We don't have a config file to load.
	# open file
	var config_file = FileAccess.open("user://config.json", FileAccess.READ)
	# for each line
	while config_file.get_position() < config_file.get_length():
		var json_string = config_file.get_line()
		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data
		for i in node_data.keys():
			if i == "wall_ip":
				wall_ip = node_data[i]

func send_problem(p: Problem):
	var endpoint = "http://" + wall_ip + "/load"
	print("endpoint: ", endpoint)
	var data = []
	for h in p.holds:
		data.append({"number": h.id, "color": h.type+1})
	print(JSON.stringify(data, "", false))
	var http_request = HTTPRequest.new()
	http_request.request_completed.connect(self._http_request_completed)
	add_child(http_request)
	
	var headers = ["Content-Type: application/json"]
	var error = http_request.request(endpoint, headers, HTTPClient.METHOD_POST, JSON.stringify(data, "", false))
	if error == OK:
		print("Sent.")
		print("")
	
func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()

	# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
	print(response)
	
