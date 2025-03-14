extends Control

@onready var lista = $Scroll/Lista
@onready var card = preload("res://components/problem_card.tscn")

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
func _process(delta: float) -> void:
	pass

func _on_button_problems_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)
