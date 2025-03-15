extends Object

class_name Problem

#const Hold = preload("res://scripts/Hold.gd")

var id: int
var wallid: int
var name : String
var description : String
var rating : int
var grade: String
var sends: int
var holds: Array[Hold] = []


func _init(w, n, d, r, g, s):
	id = ResourceUID.create_id()
	wallid = w
	name = n
	description = d
	rating = r
	grade = g
	sends = s
	
func addHold(h: Hold):
	holds.append(h)
	
func toJson() -> String:
	return JSON.stringify(self)
	
func fromJson(s):
	var data = JSON.parse_string(s)
	if data != null:
		self.id = data["id"]
		self.wallid = data["wallid"]
		self.name = data["name"]
		self.description = data["description"]
		self.grade = data["grade"]
		self.sends = data["sends"]
		self.holds = data["holds"]
		
