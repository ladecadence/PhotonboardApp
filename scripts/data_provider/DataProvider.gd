extends RefCounted
class_name DataProvider

# public methods

func destroy() -> void:
	push_error("destroy not implemented")

func get_problem(id: String, callback: Callable) -> void:
	push_error("get_problem not implemented")

func get_problems(callback: Callable, page: int = 0, page_size: int = 25) -> void:
	push_error("get_problems not implemented")

func get_problems_by_filter(filter: FilterProblem, callback: Callable, page: int = 0, page_size: int = 25) -> void:
	push_error("get_problems_by_filter not implemented")

func get_wall(id: String, callback: Callable) -> void:
	push_error("get_wall not implemented")

func get_walls(callback: Callable, page: int = 0, page_size: int = 25) -> void:
	push_error("get_walls not implemented")

func get_walls_ids(callback: Callable) -> void:
	push_error("get_walls_ids not implemented")

func upsert_problem(problem_data: Dictionary, callback: Callable = Callable()) -> void:
	push_error("upsert_problem not implemented")

func upsert_wall(wall_data: Dictionary, callback: Callable = Callable()) -> void:
	push_error("upsert_wall not implemented")
