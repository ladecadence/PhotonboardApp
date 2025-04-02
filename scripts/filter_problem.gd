extends Node

class_name FilterProblem

enum ORDER_BY {NOTHING, NAME, GRADE, SENDS}

var wallid: String = ""
var grade_range: Array[int] = []
var order: ORDER_BY = ORDER_BY.NOTHING

func get_db_conditions() -> String:
	var conditions = ""
	if wallid != "":
		conditions = conditions + ' id="'+wallid+'" '
	if len(grade_range) > 0:
		var grade_min = grade_range[0]
		var grade_max = grade_range[1]
		conditions =  conditions + ' grade > ' +  str(grade_min) + ' and grade < ' + str(grade_max)
	
	return conditions
