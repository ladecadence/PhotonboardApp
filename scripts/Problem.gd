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
	
func add_hold(h: Hold):
	holds.append(h)
	
func to_json() -> String:
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
		hold_array.append(h.to_dict())
		
	data["holds"] = hold_array
	
	return JSON.stringify(data)
	
func from_json(s):
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
				hold.from_dict(h)
				self.holds.append(hold)
		else:
			self.holds = []

func from_db_query(data):
	if data != null:
		self.id = data["id"]
		self.wallid = data["wallid"]
		self.name = data["name"]
		self.description = data["description"]
		self.grade = data["grade"]
		self.sends = data["sends"]
		if data.has("holds"):
			var holds_dict = JSON.parse_string(data["holds"])
			for h in holds_dict:
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
	data["id"] = id
	data["wallid"] = wallid
	data["name"] = name
	data["description"] = description
	data["rating"] = rating
	data["grade"] = grade
	data["sends"] = sends
	data["holds"] = holds_to_json()
	return data
	
func create_problem_image():
	const sizex = 200
	const sizey = 200
	const holdsize = 20
	
	var img = Image.create_empty(200, 200, false, Image.FORMAT_RGB8)
	img.fill(Color.BLACK)
	img.fill_rect(Rect2i(1, 1, sizex-2, sizex-2), Color.WHITE)
	
	# get wall image size
	var wall = Database.get_db_wall(wallid)
	print ("wall: ", wall.id, ", ", wall.img_w, ", ", wall.img_h)
	var ratiox = wall.img_w / sizex
	var ratioy = wall.img_h / sizey
	
	print("Ratios: ", ratiox, ", ", ratioy)
	
	for h in holds:
		# get hold position
		var posx = h.x
		var posy = h.y
		img.fill_rect(Rect2i((posx/ratiox)-holdsize/2, (posy/ratioy)-holdsize/2, holdsize, holdsize), Hold.holdColors[h.type])
	
	img.save_jpg("user://" + id + ".jpg")
	return img
		
