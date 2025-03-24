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
	table_problems["grade"] = {"data_type":"text", "not_null": true}
	table_problems["sends"] = {"data_type":"int", "not_null": true}
	table_problems["holds"] = {"data_type":"string", "not_null": true}
	db.create_table("problems", table_problems)
	
	# Close the current database
	db.close_db()

func create_test_data():
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
	
	# create wall data
	var data = {}
	data["id"] = wall.id
	data["name"] = wall.name
	data["description"] = wall.description
	data["adjustable"] = "true"
	data["deg_min"] = wall.deg_min
	data["deg_max"] = wall.deg_max
	var img = Image.new()
	img.load("res://images/wall0002.jpg")
	print("Img Format: ", img.get_format())
	data["image"] = img.save_jpg_to_buffer()
	data["img_w"] = img.get_width()
	data["img_h"] = img.get_height()
	data["holds"] = wall.holds_to_json()
	
	# insert it 
	db.insert_row("walls", data)
	
	# problems
	file = FileAccess.open("res://data/problems.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var json_data = JSON.parse_string(content)
	for p in json_data:
		var problem = Problem.new("", "", "", 0, "", 0)
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
	var selected_array = db.select_rows("walls", 'id="'+id+'"', ["*"])
	var query_result : Array = db.query_result
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
		var img = Image.create(wall.img_w, wall.img_h, false, Image.FORMAT_RGB8)
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
	var selected_array = db.select_rows("walls", '', ["*"])
	var query_result : Array = db.query_result
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
			wall.updateImage(img)
			wall_array.append(wall)
		return wall_array

func get_db_problem(id: String) -> Problem:
	db = SQLite.new()
	db.path = db_file
	db.verbosity_level = verbosity_level
	# Open the database using the db_name found in the path variable
	db.open_db()
	
	# get wall from id
	var selected_array = db.select_rows("problems", 'id="'+id+'"', ["*"])
	var query_result : Array = db.query_result
	var count : int = 0
	if query_result.is_empty():
		return null
	else:
		# ok, create wall
		var result : Dictionary = query_result[0]
		count = int(result.get("count", count))
		var problem = Problem.new("", "", "", 0, "", 0)
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
	var selected_array = db.select_rows("problems", '', ["*"])
	var query_result : Array = db.query_result
	var count : int = 0
	if query_result.is_empty():
		return []
	else:
		# ok, create problems
		var problem_array: Array[Problem] = []
		for result: Dictionary in query_result:
			count = int(result.get("count", count))
			var problem = Problem.new("", "", "", 0, "", 0)
			# fill data
			problem.from_db_query(result)
			# image in DB is a PackedArray with JPG data, load it
			problem_array.append(problem)
		return problem_array
