extends RefCounted

class_name Problem

const problem_image_background_color = "#262338"

var uid: String
var wallid: String
var name : String
var description : String
var rating : int
var grade: int
var sends: int
var holds: Array[Hold] = []

func _init(w = "", n = "", d = "", r = 0, g = 0, s = 0):
	uid = AppManager.get_uuid_v4()
	wallid = w
	name = n
	description = d
	rating = r
	grade = g
	sends = s

func add_hold(h: Hold):
	holds.append(h)

func to_json() -> String:
	var data = {}
	data["uid"] = self.uid
	data["wallid"] = self.wallid
	data["name"] = self.name
	data["description"] = self.description
	data["rating"] = self.rating
	data["grade"] = self.grade
	data["sends"] = self.sends 
	
	# holds
	var hold_array = []
	for h in self.holds:
		hold_array.append(h.to_dict())
		
	data["holds"] = hold_array
	
	return JSON.stringify(data)

func from_json(s):
	var data = JSON.parse_string(s)
	if data != null:
		self.uid = data["uid"]
		self.wallid = data["wallid"]
		self.name = data["name"]
		self.description = data["description"]
		self.rating = data["rating"]
		self.grade = data["grade"]
		self.sends = data["sends"]
		if data.has("holds"):
			for h in data["holds"]:
				var hold = Hold.new(0,"",0,0,0,0)
				hold.from_dict(h)
				self.holds.append(hold)
		else:
			self.holds = []

func holds_to_json():
	var hold_array = []
	for h in self.holds:
		hold_array.append(h.to_dict())
	return JSON.stringify(hold_array)

func to_dict():
	var data = {}
	data["uid"] = uid
	data["wallid"] = wallid
	data["name"] = name
	data["description"] = description
	data["rating"] = rating
	data["grade"] = grade
	data["sends"] = sends
	data["holds"] = holds_to_json()
	return data

func from_dict(data: Dictionary):
	uid = data["uid"]
	wallid = data["wallid"] 
	name = data["name"]
	description = data["description"]
	rating = data["rating"]
	grade = data["grade"]
	sends = data["sends"]
	if data.has("holds"):
		var holds_dict = JSON.parse_string(data["holds"])
		for h in holds_dict:
			var hold = Hold.new(0,"",0,0,0,0)
			hold.from_dict(h)
			holds.append(hold)
	else:
		holds = []

func to_bin() -> PackedByteArray:
	return var_to_bytes(to_dict())

func from_bin(data: PackedByteArray):
	from_dict(bytes_to_var(data))

func create_problem_image(wall: Wall):
	const sizex = 200
	const sizey = 200
	const holdsize = 20
	
	var img = Image.create_empty(200, 200, false, Image.FORMAT_RGB8)
	img.fill(Color.BLACK)
	img.fill_rect(Rect2i(1, 1, sizex-2, sizex-2), problem_image_background_color)

	# get wall image size
	var ratiox = wall.img_w / sizex
	var ratioy = wall.img_h / sizey

	for h in holds:
		# get hold position
		var posx = h.x
		var posy = h.y
		img.fill_rect(Rect2i((posx/ratiox)-holdsize/2, (posy/ratioy)-holdsize/2, holdsize, holdsize), Hold.holdColors[h.type])

	return img
