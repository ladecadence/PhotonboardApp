extends Node2D

const Hold = preload("res://scripts/Hold.gd")

var image: Texture2D = null

func loadData(tex):
	image = tex
	queue_redraw()
	
func _draw() -> void:
	draw_texture(image, Vector2())
	draw_circle(Vector2(100, 100), 30, Hold.holdColors[Hold.HOLD_TYPE.TOP], false, 5, true)
	
