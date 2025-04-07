extends DataProvider
class_name SQLiteDataProvider

const _db_path: String = "user://database.sqlite"
const _db_verbosity: int = SQLite.NORMAL
var _thread_pool: ThreadPool = null

func destroy():
	_thread_pool.destroy()

func get_problems(callback: Callable, page: int = 1, page_size: int = 25) -> void:
	_thread_pool.request(_query, ["SELECT * FROM problems LIMIT ? OFFSET ?;", [page_size, page * page_size]], callback)

func get_walls(callback: Callable, page: int = 0, page_size: int = 25) -> void:
	_thread_pool.request(_query, ["SELECT * FROM walls LIMIT ? OFFSET ?;", [page_size, page * page_size]], callback)

func _create_connection() -> SQLite:
	var connection = SQLite.new()
	connection.path = _db_path
	connection.verbosity_level = _db_verbosity
	return connection

func _init():
	if not _exists_db():
		_create_db()
		_create_test_data()
	_thread_pool = ThreadPool.new(1)

func _exists_db() -> bool:
	return FileAccess.file_exists(_db_path)

func _create_db() -> void:
	var connection = _create_connection()
	if connection.open_db():
		# walls
		var table_walls : Dictionary = Dictionary()
		table_walls["_id"] = {"data_type":"int", "primary_key": true, "not_null": true}
		table_walls["id"] = {"data_type":"text", "not_null": true}
		table_walls["name"] = {"data_type":"text", "not_null": true}
		table_walls["description"] = {"data_type":"text", "not_null": true}
		table_walls["adjustable"] = {"data_type":"int", "not_null": true}
		table_walls["deg_min"] = {"data_type":"real"}
		table_walls["deg_max"] = {"data_type":"real"}
		table_walls["image"] = {"data_type":"blob", "not_null": true}
		table_walls["img_w"] = {"data_type":"int", "not_null": true}
		table_walls["img_h"] = {"data_type":"int", "not_null": true}
		table_walls["image"] = {"data_type":"blob", "not_null": true}
		table_walls["holds"] = {"data_type":"string", "not_null": true}
		connection.create_table("walls", table_walls)
	
		# problems
		var table_problems : Dictionary = Dictionary()
		table_problems["_id"] = {"data_type":"int", "primary_key": true, "not_null": true}
		table_problems["id"] = {"data_type":"text", "not_null": true}
		table_problems["wallid"] = {"data_type":"text", "not_null": true}
		table_problems["name"] = {"data_type":"text", "not_null": true}
		table_problems["description"] = {"data_type":"text", "not_null": true}
		table_problems["rating"] = {"data_type":"real", "not_null": true}
		table_problems["grade"] = {"data_type":"int", "not_null": true}
		table_problems["grade_system"] = {"data_type":"int", "not_null": true}
		table_problems["sends"] = {"data_type":"int", "not_null": true}
		table_problems["holds"] = {"data_type":"string", "not_null": true}
		connection.create_table("problems", table_problems)
	
		# close the current database
		connection.close_db()

func _create_test_data():
	# Copy wall image to user dir. JUST FOR TESTS. TODO remove this
	var img_texture_path := "res://images/wall0003.jpg"
	var img_texture := load(img_texture_path)
	var image = img_texture.get_image()
	image.save_jpg("user://wall03.jpg", 1.0)
	
	var connection = _create_connection()
	if connection.open_db():
		var file = FileAccess.open("res://data/wall.json", FileAccess.READ)
		var json = file.get_as_text()
		file.close()
		var wall = Wall.new(null, "", "", true, 0, 0, null, 0, 0)
		wall.from_json(json)
		
		print("Image exists? : ", FileAccess.file_exists("user://wall03.jpg"))
		file = FileAccess.open("user://wall03.jpg", FileAccess.READ)
		print("Image size: ", file.get_length())
		file.close()
		
		var img = Image.load_from_file("user://wall03.jpg")
		print("inserting wall: ", img.get_width())
		wall.update_image(img)
		
		# insert it 
		connection.insert_row("walls", wall.to_dict())
		
		# problems
		file = FileAccess.open("res://data/problems.json", FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		var json_data = JSON.parse_string(content)
		for p in json_data:
			var problem = Problem.new("", "", "", 0, 0, 0, 0)
			problem.from_json(JSON.stringify(p))
			# insert it 
			connection.insert_row("problems", problem.to_dict())
		
		# Close the current database
		connection.close_db()

func _query(query: String, params: Array) -> Array:
	var results = []
	var connection = _create_connection()
	if connection.open_db():
		if connection.query_with_bindings(query, params):
			results = connection.query_result
		connection.close_db()
	return results
