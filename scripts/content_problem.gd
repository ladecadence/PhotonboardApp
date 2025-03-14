extends Control

const Hold = preload("res://scripts/Hold.gd")
const Problem = preload("res://scripts/Problem.gd")

func _ready() -> void:
	pass
	
func loadData(data):
	$Scroll/MarginPrincipal/Lista/MarginImage/Image.set_texture(ImageTexture.create_from_image(Image.load_from_file("res://images/wall0001.jpg")))
	$Scroll/MarginPrincipal/Lista/HBoxContainerNombre/Name.text = data.name
	$Scroll/MarginPrincipal/Lista/HBoxContainerNombre/MarginContainer/CenterContainer/Panel/Grade.text = data.grade
	$Scroll/MarginPrincipal/Lista/Description.text = data.description
	# calculate stars
	var stars = ""
	for i in data.rating:
		stars += "⭐"
	$Scroll/MarginPrincipal/Lista/Stars.text = stars
