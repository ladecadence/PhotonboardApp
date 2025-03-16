extends Node2D

#const Hold = preload("res://scripts/Hold.gd")
#const Wall = preload("res://scripts/Wall.gd")

enum WALL_MODE {CREATE, EDIT, SHOW}

var mode: WALL_MODE = WALL_MODE.CREATE
var image: Texture2D = null
var zoom: float = 1.0
var origin: Vector2 = Vector2(0,0)
var imageSize: Vector2
var lastTouchedCords: Vector2
var lastHold: int = 0
var wall: Wall

func loadData(w: Wall):
	self.wall = w
	lastHold = len(w.holds) # for counting the holds added (their ID)
	image = ImageTexture.create_from_image(Image.load_from_file(self.wall.image))
	imageSize = image.get_size()
	queue_redraw()
	
func _draw() -> void:
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(zoom, zoom))
	draw_texture(image, origin)
	var default_font = ThemeDB.fallback_font
	for h in wall.holds:
		# draw the circle
		draw_circle(Vector2(h.x, h.y)+origin, 30, Hold.holdColors[h.type], false, 5, true)
		# get the size of the string we are going to draw so we can center it
		var size = default_font.get_string_size(str(h.id),HORIZONTAL_ALIGNMENT_CENTER, -1, 20)
		# and draw the string of the ID
		draw_string(default_font, Vector2(h.x-size.x/2, h.y+size.y/2)+origin, str(h.id), HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Hold.holdColors[h.type])

# process events
func _input(event):
	# zoom: TODO: Fix zoom centered in pointer position
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
			if event.button_index == MOUSE_BUTTON_MIDDLE:
				print (wall.toJson())
	# touch
	if event is InputEventScreenTouch:
		# check if we moved
		if event.pressed:
			# save for when the touch is released
			lastTouchedCords = event.position
		else: # released
			# check mode
			if mode != WALL_MODE.SHOW:
				# if the vector of movement (drag) is very small, it was just a touch
				if (event.position.abs() - lastTouchedCords.abs()).length() < 2:
					# check if we can add a hold, if we are inside the image
					if event.position > origin && event.position < origin + (imageSize*zoom):
						# add the hold, beware of zoom level
						wall.holds.append(Hold.new(lastHold, wall.id, (event.position.x/zoom)-origin.x, (event.position.y/zoom)-origin.y, Hold.HOLD_TYPE.DESIGN, Hold.HOLD_SIZE.SMALL))
						lastHold+=1
						queue_redraw()
			

	# drag
	if event is InputEventScreenDrag and event.pressure != 0:
		# check if the drag vector was as least 2 units
		if event.relative.length() > 2:
			origin = origin + event.relative
			queue_redraw()

func get_wall() -> Wall:
	return wall
