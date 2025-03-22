extends Object

class_name Problem

#const Hold = preload("res://scripts/Hold.gd")

var id: String
var wallid: String
var name : String
var description : String
var rating : int
var grade: String
var sends: int
var holds: Array[Hold] = []


func _init(w, n, d, r, g, s):
	id = AppManager.get_uuid_v4()
	wallid = w
	name = n
	description = d
	rating = r
	grade = g
	sends = s
	
func addHold(h: Hold):
	holds.append(h)
	
func toJson() -> String:
	var data = {}
	data["id"] = self.id
	data["wallid"] = self.wallid
	data["name"] = self.name
	data["description"] = self.description
	data["rating"] = self.rating
	data["grade"] = self.grade
	data["sends"] = self.sends 
	
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
		self.wallid = data["wallid"]
		self.name = data["name"]
		self.description = data["description"]
		self.grade = data["grade"]
		self.sends = data["sends"]
		if data.has("holds"):
			for h in data["holds"]:
				var hold = Hold.new(0,"",0,0,0,0)
				hold.fromDict(h)
				self.holds.append(hold)
		else:
			self.holds = []
		
