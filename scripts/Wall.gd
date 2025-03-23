extends Object

class_name Wall

#const Hold = preload("res://scripts/Hold.gd")
#const Problem = preload("res://scripts/Problem.gd")

var id: String
var name : String
var description : String
var adjustable : bool
var deg_min: int
var deg_max: int
var image: Image
var img_w: int
var img_h: int
var holds: Array[Hold]


func _init(_id, n, d, a, dmin, dmax, i, iw, ih):
	if _id == null:
		id = AppManager.get_uuid_v4()
	else:
		id = _id
	name = n
	description = d
	adjustable = a
	deg_min = dmin
	deg_max = dmax
	image = i
	img_w = iw
	img_h = ih
	holds = []
	
	
func updateImage(img):
	image = img

func addHolds(h: Array[Hold]):
	holds = h
	
func addHold(h: Hold):
	holds.append(h)

func toJson() -> String:
	var data = {}
	data["id"] = self.id
	data["name"] = self.name
	data["description"] = self.description
	data["adjustable"] = self.adjustable
	data["deg_min"] = self.deg_min
	data["deg_max"] = self.deg_max 
	# data["image"] = self.image.save_jpg_to_buffer()
	
	# holds
	var hold_array = []
	for h in self.holds:
		hold_array.append(h.toDict())
		
	data["holds"] = hold_array
	
	return JSON.stringify(data)
	
func fromJson(s):
	var data = JSON.parse_string(s)
	fromDict(data)
	
func fromDict(data):
	if data != null:
		self.id = data["id"]
		self.name = data["name"]
		self.description = data["description"]
		self.adjustable = data["adjustable"]
		self.deg_min = data["deg_min"]
		self.deg_max = data["deg_max"]
		# self.image = Image.create_from_data(data["image"])
		if data.has("holds"):
			for h in data["holds"]:
				var hold = Hold.new(0,"",0,0,0,0)
				hold.fromDict(h)
				self.holds.append(hold)
		else:
			self.holds = []

func from_db_query(data):
	if data != null:
		self.id = data["id"]
		self.name = data["name"]
		self.description = data["description"]
		self.adjustable = true if data["adjustable"] == "true" else false
		self.deg_min = data["deg_min"]
		self.deg_max = data["deg_max"]
		# self.image = Image.create_from_data(data["image"])
		if data.has("holds"):
			var holds_dict = JSON.parse_string(data["holds"])
			for h in holds_dict:
				var hold = Hold.new(0,"",0,0,0,0)
				hold.fromDict(h)
				self.holds.append(hold)
		else:
			self.holds = []

func holds_to_json():
	var hold_array = []
	for h in self.holds:
		hold_array.append(h.toDict())
	return JSON.stringify(hold_array)
