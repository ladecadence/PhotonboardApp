extends Node

class_name Grade

enum GRADE_SYSTEMS {FONT, HUECO}

const GRADES_FONT = {
	1: "3",
	2: "4-",
	3: "4",
	4: "4+",
	5: "5",
	6: "5+",
	7: "6A",
	8: "6A+",
	9: "6B",
	10: "6B+",
	11: "6C",
	12: "6C+",
	13: "7A",
	14: "7A+",
	15: "7B",
	16: "7B+",
	17: "7C",
	18: "7C+",
	19: "8A",
	20: "8A+",
	21: "8B",
	22: "8B+",
	23: "8C",
	24: "8C+",
	25: "9A"
}
const GRADES_HUECO = {
	1: "VB", 
	2: "V0-", 
	3: "V0", 
	4: "V0+",
	5: "V1",
	6: "V2",
	7: "V3",
	8: "V3/V4",
	9: "V4",
	10: "V4/V5",
	11: "V5",
	12: "V5/V6",
	13: "V6",
	14: "V7",
	15: "V8",
	16: "V8/V9",
	17: "V9",
	18: "V10",
	19: "V11",
	20: "V12",
	21: "V13",
	22: "V14",
	23: "V15",
	24: "V16",
	25: "V17"
	}
	
static func font_to_hueco(g) -> String:
	if typeof(g) == TYPE_INT:
		return GRADES_HUECO[g]
	else:
		for k in GRADES_FONT:
			if GRADES_FONT[k] == g:
				return GRADES_HUECO[k]
	return ""

static func hueco_to_font(g) -> String:
	if typeof(g) == TYPE_INT:
		return GRADES_FONT[g]
	else:
		for k in GRADES_HUECO:
			if GRADES_HUECO[k] == g:
				return GRADES_FONT[k]
	return ""
