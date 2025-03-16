extends Control

@onready var lista = $Scroll/Lista
@onready var card = preload("res://components/problem_card.tscn")

#const Wall = preload("res://scripts/Wall.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# delete cards
	for child in lista.get_children():
		child.queue_free()
	
	# load data
	var file = FileAccess.open("res://data/problems.json", FileAccess.READ)
	var content = file.get_as_text()
	var jsonData = JSON.parse_string(content)
	
	for p in jsonData:
		var c = card.instantiate()
		var problem = Problem.new(p["wallid"], p["name"], p["description"],
		 p["rating"], p["grade"], p["sends"])
		
		c.load_data(problem)
		lista.add_child(c)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_button_problems_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)


func _on_button_walls_pressed() -> void:
	# TODO: remove after wall widget is ready
	# var wall = Wall.new("Rocuadramo", "Best wall", true, 5, 40, "user://wall01.jpg")
	var wall = Wall.new("", "", true, 0, 0, "")
	var json = '{"adjustable":true,"deg_max":40,"deg_min":5,"description":"Best wall","holds":[{"id":0,"size":20,"type":0,"wallid":6953029355443832832,"x":30.0,"y":53.0},{"id":1,"size":20,"type":0,"wallid":6953029355443832832,"x":141.0,"y":75.0},{"id":2,"size":20,"type":0,"wallid":6953029355443832832,"x":356.0,"y":43.0},{"id":3,"size":20,"type":0,"wallid":6953029355443832832,"x":469.0,"y":41.0},{"id":4,"size":20,"type":0,"wallid":6953029355443832832,"x":567.0,"y":48.0},{"id":5,"size":20,"type":0,"wallid":6953029355443832832,"x":732.0,"y":28.0},{"id":6,"size":20,"type":0,"wallid":6953029355443832832,"x":85.0,"y":111.0},{"id":7,"size":20,"type":0,"wallid":6953029355443832832,"x":256.0,"y":106.0},{"id":8,"size":20,"type":0,"wallid":6953029355443832832,"x":341.0,"y":100.0},{"id":9,"size":20,"type":0,"wallid":6953029355443832832,"x":508.0,"y":91.0},{"id":10,"size":20,"type":0,"wallid":6953029355443832832,"x":587.0,"y":105.0},{"id":11,"size":20,"type":0,"wallid":6953029355443832832,"x":663.0,"y":86.0},{"id":12,"size":20,"type":0,"wallid":6953029355443832832,"x":771.0,"y":86.0}],"id":6953029355443832832,"image":"user://wall01.jpg","name":"Rocuadramo"}'
	wall.fromJson(json)
	AppManager.load_screen(AppManager.Screen.TEST_WALLWIDGET, wall)
