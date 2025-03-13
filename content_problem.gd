extends Control

const Hold = preload("res://scripts/Hold.gd")
const Problem = preload("res://scripts/Problem.gd")

func _ready() -> void:
	pass
	
func loadData(data: Problem):
	$Scroll/Lista/MarginContainer/Image.texture = ImageTexture.create_from_image(Image.load_from_file("res://images/wall0001.jpg"))
	$Scroll/Lista/Name.text = data.name
	$Scroll/Lista/Description.text = data.description
