extends DataProvider
class_name SQLiteDataProvider

# attributes

const _db_path: String = "user://database.sqlite"
const _db_verbosity: int = SQLite.QUIET
var _thread_pool: ThreadPool = null

# public methods

func destroy():
	_thread_pool.destroy()
	_thread_pool = null

func get_problem(uid: String, callback: Callable) -> void:
	assert(_thread_pool, "expected a valid thread pool")
	_thread_pool.request(_query, ["SELECT * FROM problems WHERE uid = ? LIMIT 1;", [uid]], 
		func(problem_data: Array):
			if callback.is_valid():
				callback.callv([problem_data.front()])
	)

func get_problems(callback: Callable, page: int = 0, page_size: int = 25) -> void:
	assert(_thread_pool, "expected a valid thread pool")
	_thread_pool.request(_query, ["SELECT * FROM problems LIMIT ? OFFSET ?;", [page_size, page * page_size]], callback)

func get_problems_by_filter(filter: FilterProblem, callback: Callable, page: int = 0, page_size: int = 25) -> void:
	assert(_thread_pool, "expected a valid thread pool")
	var query = "SELECT * FROM problems"
	var params = []
	if filter.filter_active:
		query += " WHERE"
	if filter.wallid != "":
		query += " wallid = ?"
		params.append(filter.wallid)
		if len(filter.grade_range) > 0:
			query += " AND"
	if len(filter.grade_range) > 0:
		query += " grade >= ? AND grade <= ?"
		params.append(filter.grade_range[0])
		params.append(filter.grade_range[1])
	if filter.order != FilterProblem.ORDER_BY.NOTHING:
		query += " ORDER BY %s %s" % [filter.get_order(), filter.get_order_dir()]
	query += " LIMIT ? OFFSET ?;"
	params.append(page_size)
	params.append(page * page_size)
	_thread_pool.request(_query, [query, params], callback)

func get_wall(uid: String, callback: Callable) -> void:
	assert(_thread_pool, "expected a valid thread pool")
	_thread_pool.request(_query, ["SELECT * FROM walls WHERE uid = ? LIMIT 1;", [uid]], 
		func(wall_data: Array):
			if callback.is_valid():
				callback.callv([wall_data.front()])
	)

func get_walls(callback: Callable, page: int = 0, page_size: int = 25) -> void:
	assert(_thread_pool, "expected a valid thread pool")
	_thread_pool.request(_query, ["SELECT * FROM walls LIMIT ? OFFSET ?;", [page_size, page * page_size]], callback)
	
func get_walls_ids(callback: Callable) -> void:
	assert(_thread_pool, "expected a valid thread pool")
	_thread_pool.request(_query, ["SELECT uid FROM walls;", []], callback)

func upsert_problem(problem_data: Dictionary, callback: Callable = Callable()) -> void:
	assert(_thread_pool, "expected a valid thread pool")
	get_problem(problem_data["uid"], 
		func(problem):
			if problem:
				_thread_pool.request(_update, ["problems", 'uid="' + problem.uid + '"', problem_data], callback)
			else:
				_thread_pool.request(_insert, ["problems", problem_data], callback)
	)

func upsert_wall(wall_data: Dictionary, callback: Callable = Callable()) -> void:
	assert(_thread_pool, "expected a valid thread pool")
	get_wall(wall_data["uid"], 
		func(wall):
			if wall:
				_thread_pool.request(_update, ["walls", 'uid="' + wall.uid + '"', wall_data], callback)
			else:
				_thread_pool.request(_insert, ["walls", wall_data], callback)
	)

# private methods

func _create_connection() -> SQLite:
	var connection = SQLite.new()
	connection.path = _db_path
	connection.verbosity_level = _db_verbosity
	return connection

func _create_db() -> void:
	var connection = _create_connection()
	if connection.open_db():
		# walls
		var table_walls : Dictionary = Dictionary()
		table_walls["id"] = {"data_type":"int", "primary_key": true, "not_null": true}
		table_walls["uid"] = {"data_type":"text", "not_null": true}
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
		table_problems["id"] = {"data_type":"int", "primary_key": true, "not_null": true}
		table_problems["uid"] = {"data_type":"text", "not_null": true}
		table_problems["wallid"] = {"data_type":"text", "not_null": true}
		table_problems["name"] = {"data_type":"text", "not_null": true}
		table_problems["description"] = {"data_type":"text", "not_null": true}
		table_problems["rating"] = {"data_type":"int", "not_null": true}
		table_problems["grade"] = {"data_type":"int", "not_null": true}
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
		var wall = Wall.new()
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
			var problem = Problem.new()
			problem.from_json(JSON.stringify(p))
			# insert it 
			connection.insert_row("problems", problem.to_dict())
		
		# Close the current database
		connection.close_db()

func _exists_db() -> bool:
	return FileAccess.file_exists(_db_path)

func _init():
	if not _exists_db():
		_create_db()
		_create_test_data()
	_thread_pool = ThreadPool.new(1)

func _insert(table: String, data: Dictionary) -> bool:
	var inserted: bool = false
	var connection = _create_connection()
	if connection.open_db():
		inserted = connection.insert_row(table, data)
		connection.close_db()
	return inserted

func _query(query: String, params: Array) -> Array:
	var data: Array = []
	var connection = _create_connection()
	if connection.open_db():
		if connection.query_with_bindings(query, params):
			data = connection.query_result
		connection.close_db()
	return data

func _update(table: String, condition: String, data: Dictionary) -> bool:
	var updated: bool = false
	var connection = _create_connection()
	if connection.open_db():
		updated = connection.update_rows(table, condition, data)
		connection.close_db()
	return updated
