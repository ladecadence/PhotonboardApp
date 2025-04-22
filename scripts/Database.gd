extends Node

# private attributes

var _data_provider: DataProvider = null

# public attributes

var data_provider: DataProvider:
	get: return _data_provider
	set(provider):
		if _data_provider:
			_data_provider.destroy()
			_data_provider = null
		_data_provider = provider

# public methods

func get_problem(uid: String, callback: Callable) -> void:
	assert(data_provider, "expected a valid data provider")
	data_provider.get_wall(uid, ["*"],
		func(problem_data):
			if callback.is_valid():
				var problem = null
				if typeof(problem_data) == TYPE_DICTIONARY:
					problem = Problem.new()
					problem.from_dict(problem_data)
				callback.callv([problem])
	)

func get_problems(filter: ProblemFilter, callback: Callable) -> void:
	assert(data_provider, "expected a valid data provider")
	data_provider.get_problems(["*"], 25, 0, filter,
		func(problems_data):
			if callback.is_valid():
				var problems: Array[Problem] = []
				if typeof(problems_data) == TYPE_ARRAY:
					for problem_data: Dictionary in problems_data:
						var problem = Problem.new()
						problem.from_dict(problem_data)
						problems.append(problem)
				callback.callv([problems])
	)

func get_wall(uid: String, callback: Callable) -> void:
	assert(data_provider, "expected a valid data provider")
	data_provider.get_wall(uid, ["*"],
		func(wall_data):
			if callback.is_valid():
				var wall = null
				if typeof(wall_data) == TYPE_DICTIONARY:
					wall = Wall.new()
					wall.from_dict(wall_data)
					# image in DB is a PackedArray with JPG data, load it
					var img = Image.create(1, 1, false, Image.FORMAT_RGB8)
					img.load_jpg_from_buffer(wall_data["image"])
					wall.update_image(img)
				callback.callv([wall])
	)

func get_walls(callback: Callable) -> void:
	assert(data_provider, "expected a valid data provider")
	data_provider.get_walls(["*"], 25, 0,
		func(walls_data):
			if callback.is_valid():
				var walls: Array[Wall] = []
				if typeof(walls_data) == TYPE_ARRAY:
					for wall_data: Dictionary in walls_data:
						var wall = Wall.new()
						wall.from_dict(wall_data)
						if wall_data.has("image") and wall_data["image"]:
							# image in DB is a PackedArray with JPG data, load it
							var img = Image.create(wall.img_w, wall.img_h, false, Image.FORMAT_RGB8)
							img.load_jpg_from_buffer(wall_data["image"])
							wall.update_image(img)
						walls.append(wall)
				callback.callv([walls])
	)

func get_walls_ids(callback: Callable) -> void:
	assert(data_provider, "expected a valid data provider")
	data_provider.get_walls(["uid"], 100, 0,
		func(walls_data):
			if callback.is_valid():
				var walls_ids: Array[String] = []
				if typeof(walls_data) == TYPE_ARRAY:
					for wall_data: Dictionary in walls_data:
						walls_ids.append(wall_data["uid"])
				callback.callv([walls_ids])
	)

func upsert_problem(p: Problem, callback: Callable = Callable()) -> void:
	assert(data_provider, "expected a valid data provider")
	data_provider.upsert_problem(
		p.to_dict(),
		func(result: bool):
			if callback.is_valid():
				callback.callv([result])
	)

func upsert_wall(w: Wall, callback: Callable = Callable()) -> void:
	assert(data_provider, "expected a valid data provider")
	data_provider.upsert_wall(
		w.to_dict(),
		func(result: bool):
			if callback.is_valid():
				callback.callv([result])
	)
