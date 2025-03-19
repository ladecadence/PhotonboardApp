extends Panel

#const Hold = preload("res://scripts/Hold.gd")
#const Wall = preload("res://scripts/Wall.gd")

enum WALL_MODE {CREATE, EDIT, SHOW}

const ZOOM_FACTOR = 0.1

var mode: WALL_MODE = WALL_MODE.CREATE
var image: Texture2D = null
var widget_size: Vector2 = Vector2(0, 0)
var widget_pos: Vector2 = Vector2(0, 0)
var zoom: float = 1.0
var offset: Vector2 = Vector2(0, 0)
var origin: Vector2 = Vector2(0, 0)
var imageSize: Vector2
var lastTouchedCords: Vector2
var lastHold: int = 0
var wall: Wall
var holdSize: Hold.HOLD_SIZE = Hold.HOLD_SIZE.SMALL

func _ready() -> void:
	pass

# offset from where the widget is drawn on the screen
func setOffset(o: Vector2):
	offset = o

func loadData(w: Wall):
	self.wall = w
	lastHold = len(w.holds) # for counting the holds already added 
	image = ImageTexture.create_from_image(Image.load_from_file(self.wall.image))
	imageSize = image.get_size()
	queue_redraw()
	
func _draw() -> void:
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(zoom, zoom))
	draw_texture(image, origin)
	var default_font = ThemeDB.fallback_font
	if wall.holds != null:
		for h in wall.holds:
			# draw the outline and the circle
			# we don't need the offset, cause we draw relative to the widget
			draw_circle(Vector2(h.x, h.y)+origin, h.size, Hold.holdColors[h.type], false, 5, true)
			# get the size of the string we are going to draw so we can center it
			var font_size = default_font.get_string_size(str(h.id),HORIZONTAL_ALIGNMENT_CENTER, -1, 20)
			# and draw the string of the ID
			draw_string(default_font, Vector2(h.x-font_size.x/2, h.y+font_size.y/2)+origin, str(h.id), HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Hold.holdColors[h.type])

# process events
func _input(event):
	# zoom: TODO: Fix zoom centered in pointer position
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				# get current mouse position inside the image
				var mouseinimage = (event.position/zoom)-origin
				zoom=zoom+ZOOM_FACTOR
				if zoom > 2:
					zoom = 2
				else: 
					# get new mouse position inside the image
					var mouseinimagenew = (event.position/zoom)-origin
					# move origin to zoom over cursor
					origin -= mouseinimage-mouseinimagenew
					queue_redraw()
				
			# zoom out
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				# get current mouse position inside the image
				var mouseinimage = (event.position/zoom)-origin
				zoom=zoom-ZOOM_FACTOR
				if zoom < 1:
					zoom = 1
				else: 
					# get new mouse position inside the image
					var mouseinimagenew = (event.position/zoom)-origin
					# move origin to zoom over cursor
					origin += mouseinimagenew-mouseinimage
					queue_redraw()

			# TEST, TODO: remove
			if event.button_index == MOUSE_BUTTON_MIDDLE:
				print(wall.toJson())
				origin = Vector2.ZERO
				queue_redraw()
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
					var mouseinimage = (event.position/zoom)-origin-offset
					if mouseinimage.x > 0 and mouseinimage.y > 0 and mouseinimage.x < imageSize.x and mouseinimage.y < imageSize.y:
						# add the hold, beware of zoom level
						widget_size = get_global_rect().size
						widget_pos = get_global_rect().position
						print ("Pos: ", widget_pos, " Size: ", widget_size)
						print(event.position)
						# check also that we are inside the widget
						if event.position.x > widget_pos.x and event.position.y > widget_pos.y and event.position.x < widget_pos.x+widget_size.x and event.position.y < widget_pos.y+widget_size.y:
							if mode == WALL_MODE.CREATE:
								# add new hold
								# TODO: This is a fix I don't understand, I calculated this using empirical data and it works, but I don't know
								# why I need to multiply the Y offset (a constant value) by the inverse of the zoom when zooming
								# I suspect it has to do with the matrix transform of the scene, but well...
								wall.holds.append(Hold.new(lastHold, wall.id, (event.position.x/zoom)-origin.x-offset.x, (event.position.y/zoom)-origin.y-(offset.y*(1/zoom)), Hold.HOLD_TYPE.DESIGN, holdSize))
								lastHold+=1
							else:
								# TODO: change existing holds
								# check if we are inside a hold
								pass 
							queue_redraw()
			
	# drag
	if event is InputEventScreenDrag and event.pressure != 0:
		# check if the drag vector was as least 2 units
		if event.relative.length() > 2:
			# TODO constrain drag
			origin = origin + event.relative
			queue_redraw()

func remove_last():
	if len(wall.holds) > 0:
		wall.holds.resize(wall.holds.size()-1)
		lastHold -= 1
		queue_redraw()
		
func set_hold_size(size: Hold.HOLD_SIZE ):
	holdSize = size

func get_wall() -> Wall:
	return wall
