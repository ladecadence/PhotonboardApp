extends MarginContainer

const Problem = preload("res://scripts/Problem.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_data(data: Problem):
	$Fondo/HBoxContainer/Descr/Name.text = data.name
	$Fondo/HBoxContainer/Descr/Description.text = data.description
	# calculate stars
	var stars = ""
	for i in data.rating:
		stars += "⭐"
	$Fondo/HBoxContainer/Descr/Stars.text = stars
	$Fondo/HBoxContainer/Data/MarginContainer/CenterContainer/Panel/Grade.text = data.grade
	$Fondo/HBoxContainer/Data/Sends/Number.text = str(data.sends)
	
