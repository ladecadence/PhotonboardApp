extends MarginContainer

func _ready() -> void:
	$VBoxContainer/MarginContainer/WallWidget.setOffset($VBoxContainer/Header.get_rect().size)

func loadData(data):
	$VBoxContainer/MarginContainer/WallWidget.loadData(data)
