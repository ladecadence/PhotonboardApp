extends RefCounted
class_name DataProvider

func destroy() -> void:
	push_error("destroy not implemented")

func get_problems(callback: Callable, page: int = 1, page_size: int = 10) -> void:
	push_error("get_problems not implemented")

func get_walls(callback: Callable, page: int = 1, page_size: int = 10) -> void:
	push_error("get_walls not implemented")
