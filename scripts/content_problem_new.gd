extends Control

func _ready() -> void:
	for wall in Database.get_db_walls():
		$MarginContainer/Scroll/Lista/HBoxContainer6/OptionWall.add_item(wall.name)
	for grade in Grade.GRADES_FONT:
		$MarginContainer/Scroll/Lista/HBoxContainer4/OptionGrade.add_item(Grade.GRADES_FONT[grade])
