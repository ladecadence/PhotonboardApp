extends RefCounted

class_name Wall

#const Hold = preload("res://scripts/Hold.gd")
#const Problem = preload("res://scripts/Problem.gd")

var uid: String
var name : String
var description : String
var adjustable : bool
var deg_min: int
var deg_max: int
var image: Image
var img_w: int
var img_h: int
var holds: Array[Hold]

func _init(_id = null, n = "", d = "", a = true, dmin = 0, dmax = 0, i = null, iw = 0, ih = 0):
	if _id == null:
		uid = AppManager.get_uuid_v4()
	else:
		uid = _id
	name = n
	description = d
	adjustable = a
	deg_min = dmin
	deg_max = dmax
	image = i
	img_w = iw
	img_h = ih
	holds = []
	
func update_image(img: Image):
	image = img
	img_w = img.get_width()
	img_h = img.get_height()

func add_holds(h: Array[Hold]):
	holds = h
	
func add_hold(h: Hold):
	holds.append(h)

func to_json() -> String:
	var data = {}
	data["uid"] = self.uid
	data["name"] = self.name
	data["description"] = self.description
	data["adjustable"] = self.adjustable
	data["deg_min"] = self.deg_min
	data["deg_max"] = self.deg_max 
	# data["image"] = self.image.save_jpg_to_buffer()
	
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
		self.name = data["name"]
		self.description = data["description"]
		self.adjustable = data["adjustable"]
		self.deg_min = data["deg_min"]
		self.deg_max = data["deg_max"]
		# self.image = Image.create_from_data(data["image"])
		if data.has("holds"):
			for h in data["holds"]:
				var hold = Hold.new(0,"",0,0,0,0)
				hold.from_dict(h)
				self.holds.append(hold)
		else:
			self.holds = []
	
func from_dict(data):
	if data != null:
		self.uid = data["uid"]
		self.name = data["name"]
		self.description = data["description"]
		self.adjustable = data["adjustable"]
		self.deg_min = data["deg_min"]
		self.deg_max = data["deg_max"]
		# self.image = Image.create_from_data(data["image"])
		if data.has("holds") and data["holds"]:
			var dict = JSON.parse_string(data["holds"])
			for h in dict:
				var hold = Hold.new(0,"",0,0,0,0)
				hold.from_dict(h)
				self.holds.append(hold)
		else:
			self.holds = []

func to_bin() -> PackedByteArray:
	var dict = to_dict()
	dict["image"] = image.save_jpg_to_buffer(1.0)
	return var_to_bytes(dict)
	
func from_bin(data: PackedByteArray):
	var dict = bytes_to_var(data)
	from_dict(dict)
	image = Image.new()
	image.load_jpg_from_buffer(dict["image"])

func holds_to_json():
	var hold_array = []
	for h in self.holds:
		hold_array.append(h.to_dict())
	return JSON.stringify(hold_array)

func to_dict():
	# create wall data
	var data = {}
	data["uid"] = uid
	data["name"] = name
	data["description"] = description
	data["adjustable"] = adjustable
	data["deg_min"] = deg_min
	data["deg_max"] = deg_max
	data["image"] = image.save_jpg_to_buffer()
	data["img_w"] = image.get_width()
	data["img_h"] = image.get_height()
	data["holds"] = holds_to_json()
	
	return data
