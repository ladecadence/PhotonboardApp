extends Node

# database
const verbosity_level : int = SQLite.NORMAL
var db_file := "user://database.sqlite"
var data_provider: DataProvider = SQLiteDataProvider.new()

func get_db_wall(id: String) -> Wall:
	var db = SQLite.new()
	db.path = db_file
	db.verbosity_level = verbosity_level
	# Open the database using the db_name found in the path variable
	db.open_db()
	
	# get wall from id
	var _selected_array = db.select_rows("walls", 'id="'+id+'"', ["*"])
	var query_result : Array = db.query_result
	# Close the current database
	db.close_db()
	var count : int = 0
	if query_result.is_empty():
		return null
	else:
		# ok, create wall
		var result : Dictionary = query_result[0]
		count = int(result.get("count", count))
		var wall = Wall.new(null, "", "", true, 0, 0, null, 0, 0)
		# fill data
		wall.from_db_query(result)
		# image in DB is a PackedArray with JPG data, load it
		var img = Image.create(1, 1, false, Image.FORMAT_RGB8)
		img.load_jpg_from_buffer(result["image"])
		wall.update_image(img)
		return wall
		
func get_walls(callback: Callable) -> void:
	data_provider.get_walls(
		func(results):
			if callback.is_valid():
				var count : int = 0
				if results.is_empty():
					callback.call([])
				else:
					# ok, create walls
					var wall_array: Array[Wall] = []
					for result: Dictionary in results:
						count = int(result.get("count", count))
						var wall = Wall.new(null, "", "", true, 0, 0, null, 0, 0)
						# fill data
						wall.from_db_query(result)
						# image in DB is a PackedArray with JPG data, load it
						var img = Image.create(wall.img_w, wall.img_h, false, Image.FORMAT_RGB8)
						img.load_jpg_from_buffer(result["image"])
						wall.update_image(img)
						wall_array.append(wall)
					callback.call(wall_array)
	)

func get_db_wall_ids() -> Array[String]:
	var db = SQLite.new()
	db.path = db_file
	db.verbosity_level = verbosity_level
	# Open the database using the db_name found in the path variable
	db.open_db()
	
	# get wall from id
	var _selected_array = db.select_rows("walls", '', ["id"])
	var query_result : Array = db.query_result
	# Close the current database
	db.close_db()
	var count : int = 0
	if query_result.is_empty():
		return []
	else:
		# ok, create walls
		var wall_array: Array[String] = []
		for result: Dictionary in query_result:
			count = int(result.get("count", count))
			wall_array.append(result["id"])
		return wall_array

func get_db_problem(id: String) -> Problem:
	var db = SQLite.new()
	db.path = db_file
	db.verbosity_level = verbosity_level
	# Open the database using the db_name found in the path variable
	db.open_db()
	
	# get problem from id
	var _selected_array = db.select_rows("problems", 'id="'+id+'"', ["*"])
	var query_result : Array = db.query_result
	# Close the current database
	db.close_db()
	var count : int = 0
	if query_result.is_empty():
		return null
	else:
		# ok, create wall
		var result : Dictionary = query_result[0]
		count = int(result.get("count", count))
		var problem = Problem.new("", "", "", 0, 0, 0, 0)
		# fill data
		problem.from_db_query(result)
		# image in DB is a PackedArray with JPG data, load it
		return problem

func get_problems(callback: Callable) -> void:
	data_provider.get_problems(
		func(results):
			if callback.is_valid():
				var count : int = 0
				if results.is_empty():
					callback.call([])
				else:
					# ok, create problems
					var problem_array: Array[Problem] = []
					for result: Dictionary in results:
						count = int(result.get("count", count))
						var problem = Problem.new("", "", "", 0, 0, 0, 0)
						# fill data
						problem.from_db_query(result)
						# image in DB is a PackedArray with JPG data, load it
						problem_array.append(problem)
					callback.call(problem_array)
	)

func get_db_problems_filter(filter: FilterProblem) -> Array[Problem]:
	var db = SQLite.new()
	db.path = db_file
	db.verbosity_level = verbosity_level
	# Open the database using the db_name found in the path variable
	db.open_db()
	
	# get problem with filter
	# var _selected_array = db.select_rows("problems", filter.get_db_conditions(), ["*"])
	var query = "SELECT * FROM problems"
	if AppManager.filter_problem.filter_active:
		query += " WHERE"
	if AppManager.filter_problem.wallid != "":
		query += " wallid='" + AppManager.filter_problem.wallid + "'"
		if len(AppManager.filter_problem.grade_range) > 0:
			query += " AND"
	if len(AppManager.filter_problem.grade_range) > 0:
		query += " grade>=" + str(AppManager.filter_problem.grade_range[0]) + " AND grade<=" + str(AppManager.filter_problem.grade_range[1])
	if AppManager.filter_problem.order != FilterProblem.ORDER_BY.NOTHING:
		query += " ORDER BY "
		query += AppManager.filter_problem.get_order()
		query += AppManager.filter_problem.get_order_dir()
	print("QUERY: ", query)
	var _selected_array = db.query(query)
	var query_result : Array = db.query_result
	var count : int = 0
	if query_result.is_empty():
		return []
	else:
		# ok, create problems
		var problem_array: Array[Problem] = []
		for result: Dictionary in query_result:
			count = int(result.get("count", count))
			var problem = Problem.new("", "", "", 0, 0, 0, 0)
			# fill data
			problem.from_db_query(result)
			# image in DB is a PackedArray with JPG data, load it
			problem_array.append(problem)
		return problem_array

func insert_db_problem(p: Problem):
	var db = SQLite.new()
	db.path = db_file
	db.verbosity_level = verbosity_level
	# Open the database using the db_name found in the path variable
	db.open_db()
	
	# check if it exists
	var _selected_array = db.select_rows("problems", 'id="'+p.id+'"', ["*"])
	var query_result : Array = db.query_result
	if query_result.is_empty():
		# if it's empty insert it
		db.insert_row("problems", p.to_dict())
	else:
		# update it
		db.update_rows("problems", 'id="'+p.id+'"', p.to_dict())
	
	# Close the current database
	db.close_db()

func insert_db_wall(w: Wall):
	var db = SQLite.new()
	db.path = db_file
	db.verbosity_level = verbosity_level
	# Open the database using the db_name found in the path variable
	db.open_db()
	
	# check if it exists
	# get wall from id
	var _selected_array = db.select_rows("walls", 'id="'+w.id+'"', ["*"])
	var query_result : Array = db.query_result
	if query_result.is_empty():
		# if it's empty insert it
		db.insert_row("walls", w.to_dict())
	else:
		# update it
		db.update_rows("walls", 'id="'+w.id+'"', w.to_dict())
	
	# Close the current database
	db.close_db()
