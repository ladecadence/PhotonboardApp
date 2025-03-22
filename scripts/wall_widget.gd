extends Panel

class_name WallWidget
#const Hold = preload("res://scripts/Hold.gd")
#const Wall = preload("res://scripts/Wall.gd")

enum WALL_MODE {CREATE, EDIT, SHOW}

const ZOOM_FACTOR = 0.1
const ZOOM_MIN = 1
const ZOOM_MAX = 4

var mode: WALL_MODE = WALL_MODE.EDIT
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

var touch_points: Dictionary = {}
var start_zoom: float
var start_dist: float

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
	# zoom: 
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				# get current mouse position inside the image
				var mouseinimage = (event.position/zoom)-origin
				zoom=zoom+ZOOM_FACTOR
				if zoom > ZOOM_MAX:
					zoom = ZOOM_MAX
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
				if zoom < ZOOM_MIN:
					zoom = ZOOM_MIN
				else: 
					# get new mouse position inside the image
					var mouseinimagenew = (event.position/zoom)-origin
					# move origin to zoom over cursor
					origin += mouseinimagenew-mouseinimage
					queue_redraw()

			# TEST, TODO: remove
			if event.button_index == MOUSE_BUTTON_MIDDLE:
				if mode == WALL_MODE.CREATE:
					print(wall.toJson())
				elif mode == WALL_MODE.EDIT:
					# just print "active" holds
					var out_p = Problem.new("1fddf17c-3ddf-4dc7-a3d0-e3ac3d9f8b05", "Test TBK Problem", "Testing upload", 5, "7a", 1)
					for h in wall.holds:
						if h.type != Hold.HOLD_TYPE.DESIGN:
							out_p.holds.append(h)
					print(out_p.toJson())
				origin = Vector2.ZERO
				queue_redraw()
	# touch
	if event is InputEventScreenTouch:
		touch_points[event.index] = event.position
		# check if we have more tah one touch point (zoom)
		if touch_points.size() >= 2:
			var touch_point_positions = touch_points.values()
			start_dist = touch_point_positions[0].distance_to(touch_point_positions[1])
			start_zoom = zoom
		# check if we moved
		if event.pressed:
			# save for when the touch is released
			lastTouchedCords = event.position
		else: # released
			touch_points.erase(event.index)
			# check mode
			if mode != WALL_MODE.SHOW:
				# if the vector of movement (drag) is very small, it was just a touch
				if (event.position.abs() - lastTouchedCords.abs()).length() < 2:
					# check if we can add a hold, if we are inside the image
					var mouseinimage = (event.position/zoom)-origin-(offset/zoom)
					if mouseinimage.x > 0 and mouseinimage.y > 0 and mouseinimage.x < imageSize.x and mouseinimage.y < imageSize.y:
						# add the hold, beware of zoom level
						widget_size = get_global_rect().size
						widget_pos = get_global_rect().position
						#print ("Pos: ", widget_pos, " Size: ", widget_size)
						#print(event.position)
						# check also that we are inside the widget
						if event.position.x > widget_pos.x and event.position.y > widget_pos.y and event.position.x < widget_pos.x+widget_size.x and event.position.y < widget_pos.y+widget_size.y:
							if mode == WALL_MODE.CREATE:
								# add new hold
								# TODO: This is a fix I don't understand, I calculated this using empirical data and it works, but I don't know
								# why I need to multiply the Y offset (a constant value) by the inverse of the zoom when zooming
								# I suspect it has to do with the matrix transform of the scene, but well...
								wall.holds.append(Hold.new(lastHold, wall.id, (event.position.x/zoom)-origin.x-offset.x, (event.position.y/zoom)-origin.y-(offset.y*(1/zoom)), Hold.HOLD_TYPE.DESIGN, holdSize))
								lastHold+=1
							else: # EDIT_MODE
								# TODO: change existing holds
								# check if we are inside a hold
								var inside = false
								var hold_index = 0
								var holds_detected = []
								for h in wall.holds:
									if is_inside(h, mouseinimage):
										inside = true
										holds_detected.append(h.id)
								# if we were inside more than one circle
								if len(holds_detected) > 1:
									var min_dist = 0.0
									for i in range(holds_detected.size()):
										# get distance to center
										var dist = sqrt(pow(holds_detected[i].x-mouseinimage.x, 2) + pow(holds_detected[i].y-mouseinimage.y, 2))
										# if we are starting this is the minimum
										if i == 0:
											min_dist = dist
											hold_index = holds_detected[i]
										if dist < min_dist:
											min_dist = dist
											hold_index = holds_detected[i]
								elif len(holds_detected) == 1:
									hold_index = holds_detected[0]
								# so if we are inside
								if inside:
									wall.holds[hold_index].type = wall.holds[hold_index].type + 1
									if wall.holds[hold_index].type > Hold.HOLD_TYPE.TOP:
										wall.holds[hold_index].type = Hold.HOLD_TYPE.DESIGN
								
							queue_redraw()
					else:
						print("Out: ", mouseinimage)
	# drag an zoom with gestures TODO: zoom on mobile
	if event is InputEventScreenDrag and event.pressure != 0:
		touch_points[event.index] = event.position
		# Handle 1 touch point (drag)
		if touch_points.size() == 1:
			# check if the drag vector was as least 2 units
			if event.relative.length() > 2:
				# TODO constrain drag
				origin = origin + (event.relative/zoom)
				queue_redraw()
				
		# Handle 2 touch points
		elif touch_points.size() == 2:
			var touch_point_positions = touch_points.values()
			var current_dist = touch_point_positions[0].distance_to(touch_point_positions[1])
			var center_point = touch_point_positions[0].lerp(touch_point_positions[1], 0.5); 
			var mouseinimage = (center_point/zoom)-origin

			if current_dist > start_dist:
				# zoom in
				zoom += ZOOM_FACTOR / 2
				if zoom > ZOOM_MAX:
					zoom = ZOOM_MAX
				else: 
					var mouseinimagenew = (center_point/zoom)-origin
					origin -= mouseinimage-mouseinimagenew
				
			elif current_dist < start_dist:
				# zoom out
				zoom -= ZOOM_FACTOR / 2
				if zoom < ZOOM_MIN:
					zoom = ZOOM_MIN
				else: 
					var mouseinimagenew = (center_point/zoom)-origin
					origin += mouseinimagenew-mouseinimage
			
			start_dist = current_dist
			queue_redraw()

func remove_last():
	if len(wall.holds) > 0:
		wall.holds.resize(wall.holds.size()-1)
		lastHold -= 1
		queue_redraw()
		
func set_hold_size(s: Hold.HOLD_SIZE ):
	holdSize = s

func change_mode(m: WALL_MODE):
	mode = m

func get_wall() -> Wall:
	return wall

func is_inside(h: Hold, pos: Vector2):
	return sqrt((pos.x-h.x)*(pos.x-h.x)+(pos.y-h.y)*(pos.y-h.y)) < h.size
