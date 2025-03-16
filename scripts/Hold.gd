extends Object

class_name Hold

enum HOLD_TYPE {DESIGN, START, FOOT, HOLD, TOP}
enum HOLD_SIZE {SMALL = 20, MEDIUM = 30, BIG = 40}

const holdColors = [Color(Color.DIM_GRAY, 0.5) , Color(Color.AQUAMARINE, 0.8), Color(Color.CORAL, 0.8), Color(Color.DEEP_SKY_BLUE, 0.8), Color(Color.VIOLET, 0.8)]

var id: int
var wallid: int
var x: float
var y: float
var type: HOLD_TYPE = HOLD_TYPE.DESIGN
var size: HOLD_SIZE = HOLD_SIZE.SMALL

func _init(_i, _w, _x, _y, _t, _s):
	id = _i
	wallid = _w
	x = _x
	y = _y
	type = _t
	size = _s

func toDict():
	var data = {}
	data["id"] = self.id
	data["wallid"] = self.wallid
	data["x"] = self.x
	data["y"] = self.y
	data["type"] = self.type
	data["size"] = self.size
	return data

func fromDict(data):
	self.id = data["id"]
	self.wallid = data["wallid"]
	self.x = data["x"]
	self.y = data["y"]
	self.type = data["type"]
	self.size = data["size"]
