extends RefCounted

class_name Hold

enum HOLD_TYPE {DESIGN = 0, START = 1, TOP = 2, HOLD = 3, FEET = 4}
enum HOLD_SIZE {SMALL = 20, MEDIUM = 30, BIG = 40}

const holdColors = [Color(Color.CRIMSON, 0.5), Color(Color.CHARTREUSE, 0.8), Color(Color.MAGENTA, 0.8), Color(Color.DEEP_SKY_BLUE, 0.8), Color(Color.GOLD, 0.8)]

var id: int
var wallid: String
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

func to_dict():
	var data = {}
	data["id"] = self.id
	data["wallid"] = self.wallid
	data["x"] = self.x
	data["y"] = self.y
	data["type"] = self.type
	data["size"] = self.size
	return data

func from_dict(data):
	self.id = data["id"]
	self.wallid = data["wallid"]
	self.x = data["x"]
	self.y = data["y"]
	self.type = data["type"]
	self.size = data["size"]
