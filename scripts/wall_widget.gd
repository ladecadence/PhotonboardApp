extends Node2D

const Hold = preload("res://scripts/Hold.gd")

var image: Texture2D = null
var zoom: float = 1.0
var origin: Vector2 = Vector2(0,0)
var imageSize: Vector2

func loadData(tex: Texture2D):
	image = tex
	imageSize = tex.get_size()
	queue_redraw()
	
func _draw() -> void:
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(zoom, zoom))
	draw_texture(image, origin)
	draw_circle(Vector2(100, 100)+origin, 30, Hold.holdColors[Hold.HOLD_TYPE.TOP], false, 5, true)
	

# process events
func _input(event):
	# zoom
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom=zoom+0.1
				if zoom > 2:
					zoom = 2
				queue_redraw()
			# zoom out
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom=zoom-0.1
				if zoom < 1:
					zoom = 1
				queue_redraw()
	# drag
	if event is InputEventScreenTouch:
		print("Touched", event.as_text() )
		

	if event is InputEventScreenDrag and event.pressure != 0:
		origin = origin + event.relative
		queue_redraw()
