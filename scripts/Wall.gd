extends Object

class_name Wall

const Hold = preload("res://scripts/Hold.gd")
const Problem = preload("res://scripts/Problem.gd")

var id: int
var name : String
var description : String
var adjustable : bool
var deg_min: int
var deg_max: int
var image: String
var holds: Array[Hold]


func _init(n, d, a, dmin, dmax, i):
	id = ResourceUID.create_id()
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
	return JSON.stringify(self)
	
func fromJson(s):
	var json = JSON.new()
	var error = json.parse_string(s)
	if error == OK:
		var data = json.data
		self.id = data["id"]
		self.name = data["name"]
		self.description = data["description"]
		self.adjustable = data["adjustable"]
		self.deg_min = data["deg_min"]
		self.deg_max = data["deg_max"]
		self.image = data["image"]
		if data.has_key("holds"):
			self.holds = data["holds"]
		else:
			self.holds = []
		
