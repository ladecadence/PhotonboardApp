extends Node

class_name FilterProblem

enum ORDER_BY {NOTHING, NAME, GRADE, SENDS}

var wallid: String = ""
var grade_range: Array[int] = []
var order: ORDER_BY = ORDER_BY.NOTHING

func clear():
	wallid = ""
	grade_range.clear()

func set_wallid(wid):
	wallid = wid

func set_grade_range(gmin, gmax):
	grade_range.clear()
	grade_range.append(gmin)
	grade_range.append(gmax)

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
