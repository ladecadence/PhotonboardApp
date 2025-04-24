extends RefCounted
class_name Config

# enumerations

enum DataSource { LOCAL, CLOUD }

# private attributes

var _config_path: String

var _cloud_url: String = "http://127.0.0.1:8080/api"
var _cloud_user: String = "testuser"
var _cloud_password: String = "testpassword"
var _data_source: DataSource = DataSource.LOCAL
var _grade_system: Grade.GRADE_SYSTEMS = Grade.GRADE_SYSTEMS.FONT
var _wall_ip: String = "127.01.0.1"

# public attributes

var cloud_url: String:
	get: return _cloud_url
	set(url): _cloud_url = url

var cloud_user: String:
	get: return _cloud_user
	set(user): _cloud_user = user

var cloud_password: String:
	get: return _cloud_password
	set(password): _cloud_password = password

var data_source: DataSource:
	get: return _data_source
	set(source): _data_source = source

var grade_system: Grade.GRADE_SYSTEMS:
	get: return _grade_system
	set(system): _grade_system = system

var wall_ip: String:
	get: return _wall_ip
	set(ip): _wall_ip = ip

# public methods

func load() -> bool:
	if not FileAccess.file_exists(_config_path):
		return false

	var config_file = FileAccess.open(_config_path, FileAccess.READ)
	while config_file.get_position() < config_file.get_length():
		var json_string = config_file.get_line()
		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			push_error("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data
		for i in node_data.keys():
			if i == "cloud_url":
				cloud_url = node_data[i]
			if i == "cloud_user":
				cloud_user = node_data[i]
			if i == "cloud_password":
				cloud_password = node_data[i]
			if i == "data_source":
				data_source = node_data[i]
			if i == "grade_system":
				grade_system = node_data[i]
			if i == "wall_ip":
				wall_ip = node_data[i]

	return true

func save() -> bool:
	var data = {
		"cloud_url": cloud_url,
		"cloud_user": cloud_user,
		"cloud_password": cloud_password,
		"data_source": data_source,
		"grade_system": grade_system,
		"wall_ip": wall_ip
	}
	var config_file = FileAccess.open(_config_path, FileAccess.WRITE)
	return config_file.store_string(JSON.stringify(data))

# private methods

func _init(config_path: String):
	_config_path = config_path
