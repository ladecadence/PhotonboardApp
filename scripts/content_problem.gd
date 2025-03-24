extends Control

#const Hold = preload("res://scripts/Hold.gd")
#const Problem = preload("res://scripts/Problem.gd")

var current_problem: Problem
var current_wall: Wall

func _ready() -> void:
	$Scroll/MarginPrincipal/Lista/MarginImage/WallWidget.change_mode(WallWidget.WALL_MODE.SHOW)
	$Scroll/MarginPrincipal/Lista/MarginImage/WallWidget.change_offset($Scroll/MarginPrincipal/Lista/MarginImage/WallWidget.global_position)
	
func load_data(data):
	current_problem = data
	current_wall = Database.get_db_wall(current_problem.wallid)
	#$Scroll/MarginPrincipal/Lista/MarginImage/Image.set_texture(ImageTexture.create_from_image(Image.load_from_file("user://wall02.jpg")))
	$Scroll/MarginPrincipal/Lista/MarginImage/WallWidget.load_data(current_wall)
	$Scroll/MarginPrincipal/Lista/MarginImage/WallWidget.load_problem(current_problem)
	$Scroll/MarginPrincipal/Lista/HBoxContainerNombre/Name.text = data.name
	$Scroll/MarginPrincipal/Lista/HBoxContainerNombre/MarginContainer/CenterContainer/Panel/Grade.text = data.grade
	$Scroll/MarginPrincipal/Lista/Description.text = data.description
	# calculate stars
	var stars = ""
	for i in data.rating:
		stars += "⭐"
	$Scroll/MarginPrincipal/Lista/Stars.text = stars
	
	current_problem.create_problem_image()
