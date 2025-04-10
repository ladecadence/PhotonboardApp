extends DataProvider
class_name HttpDataProvider

# attributes

const BASE_URL := "http://127.0.0.1:8080/api"
const MIN_REQUESTS: int = 1

var _user: String
var _password: String

var _max_requests: int = MIN_REQUESTS
var _parent_node: Node = null
var _queue: Array[Dictionary] = []
var _requests: Array[HTTPRequest] = []

# public methods

func destroy() -> void:
	push_error("destroy not implemented")

func get_problem(uid: String, callback: Callable) -> void:
	_request("%s/problem/%s" % [BASE_URL, uid], _get_auth_headers(), HTTPClient.METHOD_GET, "",
		func(data):
			if callback.is_valid():
				var problem_data = {}
				if data:
					problem_data = data
					_sanitize_problem_data_from_server(problem_data)
				callback.callv([problem_data])
	)

func get_problems(callback: Callable, page: int = 0, page_size: int = 25) -> void:
	_request("%s/problems?page=%d&page_size=%d" % [BASE_URL, page, page_size], [], HTTPClient.METHOD_GET, "", 
		func(data):
			if callback.is_valid():
				var problems_data = []
				if data:
					for problem_data in data:
						_sanitize_problem_data_from_server(problem_data)
						problems_data.append(problem_data)
				callback.callv([problems_data])
	)

func get_problems_by_filter(filter: FilterProblem, callback: Callable, page: int = 0, page_size: int = 25) -> void:
	# @todo - implement filters
	_request("%s/problems?page=%d&page_size=%d" % [BASE_URL, page, page_size], [], HTTPClient.METHOD_GET, "", 
		func(data):
			if callback.is_valid():
				var problems_data = []
				if data:
					for problem_data in data:
						_sanitize_problem_data_from_server(problem_data)
						problems_data.append(problem_data)
				callback.callv([problems_data])
	)

func get_wall(uid: String, callback: Callable) -> void:
	_request("%s/wall/%s" % [BASE_URL, uid], [], HTTPClient.METHOD_GET, "",
		func(data):
			if callback.is_valid():
				var wall_data = {}
				if data:
					wall_data = data
					_sanitize_wall_data_from_server(wall_data)
				callback.callv([wall_data])
	)

func get_walls(callback: Callable, page: int = 0, page_size: int = 25) -> void:
	_request("%s/walls?page=%d&page_size=%d" % [BASE_URL, page, page_size], [], HTTPClient.METHOD_GET, "", 
		func(data):
			if callback.is_valid():
				var walls_data = []
				if data:
					for wall_data in data:
						_sanitize_wall_data_from_server(wall_data)
						walls_data.append(wall_data)
				callback.callv([walls_data])
	)

func get_walls_ids(callback: Callable) -> void:
	_request("%s/walls?fields=uid" % [BASE_URL], [], HTTPClient.METHOD_GET, "", 
		func(data):
			if callback.is_valid():
				var walls_ids = []
				if data:
					for wall_data in data:
						walls_ids.append(wall_data["uid"])
				callback.callv([walls_ids])
	)

func upsert_problem(problem_data: Dictionary, callback: Callable = Callable()) -> void:
	_sanitize_problem_data_to_server(problem_data)
	_request("%s/newproblem" % [BASE_URL], _get_auth_headers(), HTTPClient.METHOD_POST, JSON.stringify(problem_data), callback)

func upsert_wall(wall_data: Dictionary, callback: Callable = Callable()) -> void:
	_sanitize_wall_data_to_server(wall_data)
	_request("%s/newwall" % [BASE_URL], _get_auth_headers(), HTTPClient.METHOD_POST, JSON.stringify(wall_data), callback)

# private methods

func _get_auth_headers() -> Array:
	var encoded = Marshalls.utf8_to_base64("%s:%s" % [_user, _password])
	return [ "Authorization: Basic %s" % encoded, "Content-Type: application/json" ]

func _init(user: String, password: String, parent_node: Node, max_requests: int = MIN_REQUESTS) -> void:
	print("[Thread: %2s] HttpDataProvider._init { \"max_requests\": %d }" % [OS.get_thread_caller_id(), max_requests])
	_user = user
	_password = password
	_max_requests = max(MIN_REQUESTS, max_requests)
	_parent_node = parent_node

func _process_request(request: Dictionary) -> void:
	assert(_parent_node, "expected a valid parent node")
	print("[Thread: %2s] HttpDataProvider._process_request { \"method\": %s, \"url\": %s, \"callback:\" %s}" % [OS.get_thread_caller_id(), request.method, request.url, request.callback])
	var http := HTTPRequest.new()
	_parent_node.add_child(http)
	_requests.append(http)
	http.request_completed.connect(_request_done.bind(http, request.callback))
	http.request(request.url, request.headers, request.method, request.body)

func _request(url: String, headers: Array, method: HTTPClient.Method, body: String, callback: Callable) -> void:
	var request = {
		"method": method,
		"url": url,
		"headers": headers,
		"body": body,
		"callback": callback
	}
	print("[Thread: %2s] HttpDataProvider.request { \"method\": %s, \"url\": %s, \"callback:\" %s}" % [OS.get_thread_caller_id(), request.method, request.url, request.callback])
	if _requests.size() < _max_requests:
		_process_request(request)
	else:
		_queue.append(request)

func _request_done(result: HTTPRequest.Result, response_code: int, headers: PackedStringArray, body: PackedByteArray, http: HTTPRequest, callback: Callable) -> void:
	print("[Thread: %2s] HttpDataProvider._request_done { \"result\": %d, \"response_code\": %d, \"callback:\" %s}" % [OS.get_thread_caller_id(), result, response_code, callback])
	_requests.erase(http)
	http.queue_free()

	if callback.is_valid():
		callback.callv([JSON.parse_string(body.get_string_from_utf8())])

	if _queue.size() > 0:
		_process_request(_queue.pop_front())

func _sanitize_problem_data_from_server(problem_data: Dictionary) -> void:
	# replace single quotes to double quotes in holds
	problem_data["holds"] = problem_data["holds"].replace("'", "\"")

func _sanitize_problem_data_to_server(problem_data: Dictionary) -> void:
	pass

func _sanitize_wall_data_from_server(wall_data: Dictionary) -> void:
	# replace single quotes to double quotes in holds
	wall_data["holds"] = wall_data["holds"].replace("'", "\"")
	# convert base64 image data to raw data as expected by the app
	wall_data["image"] = Marshalls.base64_to_raw(wall_data["image"])

func _sanitize_wall_data_to_server(wall_data: Dictionary) -> void:
	# convert raw data to base64
	wall_data["image"] = Marshalls.raw_to_base64(wall_data["image"])
