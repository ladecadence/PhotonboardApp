extends MarginContainer

var wall: Wall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func load_data(data: Wall):
	wall = data
	$Fondo/HBoxContainer/Descr/Name.text = data.name
	$Fondo/HBoxContainer/Descr/Description.text = data.description
	if data.adjustable == true:
		$Fondo/HBoxContainer/Data/MarginContainer/CenterContainer/Panel/Degrees.text = str(data.deg_min) + "-" + str(data.deg_max) + "º"
	else:
		$Fondo/HBoxContainer/Data/MarginContainer/CenterContainer/Panel/Degrees.text = data.deg_min
