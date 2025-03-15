extends Object

class_name Hold

enum HOLD_TYPE {DESIGN, START, FOOT, HOLD, TOP}
enum HOLD_SIZE {SMALL = 20, MEDIUM = 30, BIG = 40}

const holdColors = [Color.DIM_GRAY, Color.AQUAMARINE, Color.CORAL, Color.DEEP_SKY_BLUE, Color.VIOLET]

var id: int
var wallid: int
var x: float
var y: float
var type: HOLD_TYPE = HOLD_TYPE.DESIGN
var size: HOLD_SIZE = HOLD_SIZE.SMALL

func _init(i, w, _x, _y, t, s):
	id = i
	wallid = w
	x = _x
	y = _y
	type = t
	size = s
