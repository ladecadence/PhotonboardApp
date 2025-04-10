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
	_request("%s/problem/%s" % [BASE_URL, uid], _get_auth_headers(), HTTPClient.METHOD_GET, "", callback)

func get_problems(callback: Callable, page: int = 0, page_size: int = 25) -> void:
	_request("%s/problems?page=%d&page_size=%d" % [BASE_URL, page, page_size], _get_auth_headers(), HTTPClient.METHOD_GET, "", callback)

func get_problems_by_filter(filter: FilterProblem, callback: Callable, page: int = 0, page_size: int = 25) -> void:
	_request("%s/problems/filter?page=%d&page_size=%d" % [BASE_URL, page, page_size], _get_auth_headers(), HTTPClient.METHOD_POST, JSON.stringify(filter), callback)

func get_wall(uid: String, callback: Callable) -> void:
	_request("%s/wall/%s" % [BASE_URL, uid], _get_auth_headers(), HTTPClient.METHOD_GET, "", callback)

func get_walls(callback: Callable, page: int = 0, page_size: int = 25) -> void:
	_request("%s/walls?page=%d&page_size=%d" % [BASE_URL, page, page_size], _get_auth_headers(), HTTPClient.METHOD_GET, "", callback)

func get_walls_ids(callback: Callable) -> void:
	_request("%s/walls?page=%d&page_size=%d" % [BASE_URL], _get_auth_headers(), HTTPClient.METHOD_GET, "", callback)

func upsert_problem(problem_data: Dictionary, callback: Callable = Callable()) -> void:
	_request("%s/newproblem" % [BASE_URL], _get_auth_headers(), HTTPClient.METHOD_POST, JSON.stringify(problem_data), callback)

func upsert_wall(wall_data: Dictionary, callback: Callable = Callable()) -> void:
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

	# @todo - figure out if this is the correct way to parse the result
	# we might need to parse result differently depending on the request
	# for example get_problem expects a dict and get_problems expects an array
	var response = {}
	if body.size() > 0:
		var json = JSON.new()
		if json.parse(body.get_string_from_utf8()) == OK:
			response = json.data

	if callback.is_valid():
		callback.callv([response])

	if _queue.size() > 0:
		_process_request(_queue.pop_front())
