extends Object

class_name Hold

enum HOLD_TYPE {DESIGN, START, FOOT, HOLD, TOP}
enum HOLD_SIZE {SMALL = 20, MEDIUM = 30, BIG = 40}

var id: int
var wallid: int
var x: float
var y: float
var type: HOLD_TYPE
var size: HOLD_SIZE

func _init(i, w, x, y, t, s):
	id = i
	wallid = w
	self.x = x
	self.y = y
	type = t
	size = s
