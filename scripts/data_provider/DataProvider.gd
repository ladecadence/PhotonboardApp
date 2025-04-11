extends RefCounted
class_name DataProvider

# public methods

func destroy() -> void:
	push_error("destroy not implemented")

func get_problem(uid: String, fields: Array[String], callback: Callable) -> void:
	push_error("get_problem not implemented")

func get_problems(fields: Array[String], page_size: int, page: int, filter: FilterProblem, callback: Callable) -> void:
	push_error("get_problems not implemented")

func get_wall(uid: String, fields: Array[String], callback: Callable) -> void:
	push_error("get_wall not implemented")

func get_walls(fields: Array[String], page_size: int, page: int, callback: Callable) -> void:
	push_error("get_walls not implemented")

func upsert_problem(problem_data: Dictionary, callback: Callable = Callable()) -> void:
	push_error("upsert_problem not implemented")

func upsert_wall(wall_data: Dictionary, callback: Callable = Callable()) -> void:
	push_error("upsert_wall not implemented")
