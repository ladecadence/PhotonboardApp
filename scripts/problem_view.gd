extends MarginContainer

class_name ProblemView

#const Problem = preload("res://scripts/Problem.gd")
var http_request = HTTPRequest.new()

func load_data(data):
	$VBoxContainer/ContentProblem.load_data(data)

func _on_panel_send_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		send_problem($VBoxContainer/ContentProblem.current_problem)

func _on_button_problems_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)

func _on_button_config_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.CONFIG, null)

func _on_button_walls_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.WALL_LIST, null)

func send_problem(p: Problem):
	var endpoint = "http://" + AppManager.wall_ip + "/load"
	print("endpoint: ", endpoint)
	var data = []
	for h in p.holds:
		data.append({"number": h.id, "color": h.type+1})
	print(JSON.stringify(data, "", false))
	http_request.request_completed.connect(self._http_request_completed)
	add_child(http_request)
	
	var headers = ["Content-Type: application/json"]
	var error = http_request.request(endpoint, headers, HTTPClient.METHOD_POST, JSON.stringify(data, "", false))
	if error == OK:
		print("Sent.")
		print("")
	else:
		$PopupPanelError.show()
		remove_child(http_request)
	
func _http_request_completed(_result, _response_code, _headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()

	# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
	if response == null or not response.has("success"):
		$PopupPanelError.show()
	remove_child(http_request)


func _on_button_ok_pressed() -> void:
	$PopupPanelError.hide()
