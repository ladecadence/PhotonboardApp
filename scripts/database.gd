extends Node

# database
var db : SQLite = null
const verbosity_level : int = SQLite.NORMAL
var db_file := "user://database.sqlite"

func _ready() -> void:
	# database
	if not database_exists():
		init_database()
		create_test_data()

func database_exists():
		if not FileAccess.file_exists(db_file):
			return false
		else:
			return true

func init_database():
	db = SQLite.new()
	db.path = db_file
	db.verbosity_level = verbosity_level
	# Open the database using the db_name found in the path variable
	db.open_db()
	
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
	db.create_table("walls", table_walls)
	
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
	db.create_table("problems", table_problems)
	
	# Close the current database
	db.close_db()

func create_test_data():
	# Copy wall image to user dir. JUST FOR TESTS. TODO remove this
	var img_texture_path := "res://images/wall0003.jpg"
	var img_texture := load(img_texture_path)
	var image = img_texture.get_image()
	image.save_jpg("user://wall03.jpg", 1.0)
	
	db = SQLite.new()
	db.path = db_file
	db.verbosity_level = verbosity_level
	# Open the database using the db_name found in the path variable
	db.open_db()
	
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
	db.insert_row("walls", wall.to_dict())
	
	# problems
	file = FileAccess.open("res://data/problems.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var json_data = JSON.parse_string(content)
	for p in json_data:
		var problem = Problem.new("", "", "", 0, 0, 0, 0)
		problem.from_json(JSON.stringify(p))
		# insert it 
		db.insert_row("problems", problem.to_dict())
	
	# Close the current database
	db.close_db()

func get_db_wall(id: String) -> Wall:
	db = SQLite.new()
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
		
func get_db_walls() -> Array[Wall]:
	db = SQLite.new()
	db.path = db_file
	db.verbosity_level = verbosity_level
	# Open the database using the db_name found in the path variable
	db.open_db()
	
	# get wall from id
	var _selected_array = db.select_rows("walls", '', ["*"])
	var query_result : Array = db.query_result
	# Close the current database
	db.close_db()
	var count : int = 0
	if query_result.is_empty():
		return []
	else:
		# ok, create walls
		var wall_array: Array[Wall] = []
		for result: Dictionary in query_result:
			count = int(result.get("count", count))
			var wall = Wall.new(null, "", "", true, 0, 0, null, 0, 0)
			# fill data
			wall.from_db_query(result)
			# image in DB is a PackedArray with JPG data, load it
			var img = Image.create(wall.img_w, wall.img_h, false, Image.FORMAT_RGB8)
			img.load_jpg_from_buffer(result["image"])
			wall.update_image(img)
			wall_array.append(wall)
		return wall_array

func get_db_wall_ids() -> Array[String]:
	db = SQLite.new()
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
	db = SQLite.new()
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

func get_db_problems() -> Array[Problem]:
	db = SQLite.new()
	db.path = db_file
	db.verbosity_level = verbosity_level
	# Open the database using the db_name found in the path variable
	db.open_db()
	
	# get wall from id
	var _selected_array = db.select_rows("problems", '', ["*"])
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

func get_db_problems_filter(filter: FilterProblem) -> Array[Problem]:
	db = SQLite.new()
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
		query += " ASC"
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
	db = SQLite.new()
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
	db = SQLite.new()
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
