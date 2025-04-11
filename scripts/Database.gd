extends Node

# attributes

var data_provider: DataProvider = SQLiteDataProvider.new()
# var data_provider: DataProvider = HttpDataProvider.new("testuser", "testpassword", self)

# public methods

func get_problem(id: String, callback: Callable) -> void:
	data_provider.get_wall(id, ["*"],
		func(problem_data):
			if callback.is_valid():
				var problem = null
				if problem_data:
					problem = Problem.new()
					problem.from_dict(problem_data)
				callback.callv([problem])
	)

func get_problems(filter: FilterProblem, callback: Callable) -> void:
	data_provider.get_problems(["*"], 25, 0, filter,
		func(problems_data):
			if callback.is_valid():
				var problems: Array[Problem] = []
				for problem_data: Dictionary in problems_data:
					var problem = Problem.new()
					problem.from_dict(problem_data)
					problems.append(problem)
				callback.callv([problems])
	)

func get_wall(id: String, callback: Callable) -> void:
	data_provider.get_wall(id, ["*"],
		func(wall_data):
			if callback.is_valid():
				var wall = null
				if wall_data:
					wall = Wall.new()
					wall.from_dict(wall_data)
					# image in DB is a PackedArray with JPG data, load it
					var img = Image.create(1, 1, false, Image.FORMAT_RGB8)
					img.load_jpg_from_buffer(wall_data["image"])
					wall.update_image(img)
				callback.callv([wall])
	)

func get_walls(callback: Callable) -> void:
	data_provider.get_walls(["*"], 25, 0,
		func(walls_data):
			if callback.is_valid():
				var walls: Array[Wall] = []
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
	data_provider.get_walls(["uid"], 100, 0,
		func(walls_data):
			if callback.is_valid():
				var walls_ids: Array[String] = []
				for wall_data: Dictionary in walls_data:
					walls_ids.append(wall_data["uid"])
				callback.callv([walls_ids])
	)

func upsert_problem(p: Problem, callback: Callable = Callable()) -> void:
	data_provider.upsert_problem(
		p.to_dict(),
		func(result: bool):
			if callback.is_valid():
				callback.callv([result])
	)

func upsert_wall(w: Wall, callback: Callable = Callable()) -> void:
	data_provider.upsert_wall(
		w.to_dict(),
		func(result: bool):
			if callback.is_valid():
				callback.callv([result])
	)
