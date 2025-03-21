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
var image: String
var holds: Array[Hold]


func _init(n, d, a, dmin, dmax, i):
	id = AppManager.get_uuid_v4()
	name = n
	description = d
	adjustable = a
	deg_min = dmin
	deg_max = dmax
	image = i
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
	data["image"] = self.image
	
	# holds
	var hold_array = []
	for h in self.holds:
		hold_array.append(h.toDict())
		
	data["holds"] = hold_array
	
	return JSON.stringify(data)
	
func fromJson(s):
	var data = JSON.parse_string(s)
	if data != null:
		self.id = data["id"]
		self.name = data["name"]
		self.description = data["description"]
		self.adjustable = data["adjustable"]
		self.deg_min = data["deg_min"]
		self.deg_max = data["deg_max"]
		self.image = data["image"]
		if data.has("holds"):
			for h in data["holds"]:
				var hold = Hold.new(0,"",0,0,0,0)
				hold.fromDict(h)
				self.holds.append(hold)
		else:
			self.holds = []
