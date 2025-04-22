extends RefCounted
class_name ProblemFilter

enum ORDER_BY {NOTHING, NAME, GRADE, SENDS}
enum ORDER_DIR {ASC, DESC}

# private attributes

var _wall_uid: String = ""
var _grade_range: Array[int] = [-1, -1]
var _order_by: ORDER_BY = ORDER_BY.NOTHING
var _order_dir: ORDER_DIR = ORDER_DIR.ASC

# public attributes

var grade_max: int:
	get: return _grade_range[1]
	set(grade): _grade_range[1] = grade

var grade_min: int:
	get: return _grade_range[0]
	set(grade): _grade_range[0] = grade
	
var order_by: ORDER_BY:
	get: return _order_by
	set(order): _order_by = order
	
var order_dir: ORDER_DIR:
	get: return _order_dir
	set(dir): _order_dir = dir

var wall_uid: String:
	get: return _wall_uid
	set(uid): _wall_uid = uid

# public methods

func clear():
	wall_uid = ""
	grade_max = -1
	grade_min = -1
	order_by = ORDER_BY.NOTHING
	order_dir = ORDER_DIR.ASC

func get_order_by_as_string() -> String:
	match (order_by):
		ORDER_BY.NOTHING: return ""
		ORDER_BY.NAME: return "name"
		ORDER_BY.GRADE: return "grade"
		ORDER_BY.SENDS: return "sends"
		_: return ""

func get_order_dir_as_string() -> String:
	match (order_dir):
		ORDER_DIR.ASC: return "asc"
		ORDER_DIR.DESC: return "desc"
		_: return ""

func has_grade() -> bool:
	return grade_max != -1 and grade_min != -1

func has_order_by() -> bool:
	return order_by != ORDER_BY.NOTHING

func has_wall_uid() -> bool:
	return not wall_uid.is_empty()

func is_active() -> bool:
	return has_wall_uid() or has_grade()

# private methods

func _to_string() -> String:
	var string := ""
	if has_wall_uid() :
		string = wall_uid
	if has_grade():
		if string.length() > 0: string += ","
		string += str(str(grade_max), ",", str(grade_min))
	if has_order_by():
		if string.length() > 0: string += ","
		string += get_order_by_as_string()
		if string.length() > 0: string += ","
		string += get_order_dir_as_string()
	return string
