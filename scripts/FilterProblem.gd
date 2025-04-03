extends Node

class_name FilterProblem

enum ORDER_BY {NOTHING, NAME, GRADE, SENDS}
enum ORDER_DIR {ASC, DEC}

var filter_active: bool =  false
var wallid: String = ""
var grade_range: Array[int] = []
var order: ORDER_BY = ORDER_BY.NOTHING
var order_dir: ORDER_DIR = ORDER_DIR.ASC

func clear():
	filter_active = false
	wallid = ""
	grade_range.clear()

func set_wallid(wid):
	wallid = wid
	filter_active = true

func set_grade_range(gmin, gmax):
	filter_active = true
	grade_range.clear()
	grade_range.append(gmin)
	grade_range.append(gmax)

func set_order(o: ORDER_BY):
	order = o

func get_order() -> String:
	match (order):
		ORDER_BY.NOTHING: return ""
		ORDER_BY.NAME: return "name"
		ORDER_BY.GRADE: return "grade"
		ORDER_BY.SENDS: return "sends"
		_: return ""

func set_order_dir(d: ORDER_DIR):
	order_dir = d
	
func get_order_dir() -> String:
	match (order_dir):
		ORDER_DIR.ASC: return " ASC"
		ORDER_DIR.DEC: return " DEC"
		_: return ""

func get_db_conditions() -> String:
	var conditions = ""
	if wallid != "":
		conditions = conditions + ' wallid="'+wallid+'" '
	if len(grade_range) > 0:
		var grade_min = grade_range[0]
		var grade_max = grade_range[1]
		conditions =  conditions + ' grade >= ' +  str(grade_min) + ' and grade <= ' + str(grade_max)
	
	print(conditions)
	return conditions
