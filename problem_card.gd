extends MarginContainer

const Problem = preload("res://scripts/Problem.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_data(data: Problem):
	$Fondo/HBoxContainer/Descr/Nombre.text = data.name
	$Fondo/HBoxContainer/Descr/Resumen.text = data.description
	# calculate stars
	var stars = ""
	for i in data.rating:
		stars += "⭐"
	$Fondo/HBoxContainer/Descr/Estrellas.text = stars
	$Fondo/HBoxContainer/Datos/MarginContainer/CenterContainer/Panel/Grado.text = data.grade
	$Fondo/HBoxContainer/Datos/Sends/Numero.text = str(data.sends)
	
