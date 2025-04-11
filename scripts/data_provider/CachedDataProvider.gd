extends DataProvider
class_name CachedDataProvider

# attributes

const TTL_SECONDS := 30.0
var _provider: DataProvider

var _problem_cache: Dictionary = {} 	# key: uid|fields -> { data, timestamp }
var _problems_cache: Dictionary = {} 	# key: page|size|filter|fields -> { data, timestamp }

var _wall_cache: Dictionary = {} 		# key: uid|fields -> { data, timestamp }
var _walls_cache: Dictionary = {} 		# key: page|size|fields -> { data, timestamp }

# public methods

func destroy() -> void:
	pass

func get_problem(uid: String, fields: Array[String], callback: Callable) -> void:
	var key = _build_key([uid, fields])
	if _problem_cache.has(key):
		var entry = _problem_cache[key]
		if not _is_expired(entry.timestamp):
			return callback.callv([entry.data])
		_problem_cache.erase(key)

	_provider.get_problem(uid, fields, 
		func(problem_data):
			if typeof(problem_data) == TYPE_DICTIONARY:
				_problem_cache[key] = {
					"data": problem_data,
					"timestamp": Time.get_unix_time_from_system()
				}
			if callback.is_valid():
				callback.callv([problem_data])
	)

func get_problems(fields: Array[String], page_size: int, page: int, filter: FilterProblem, callback: Callable) -> void:
	var key := _build_key([page, page_size, filter, fields])
	if _problems_cache.has(key):
		var entry = _problems_cache[key]
		if not _is_expired(entry.timestamp):
			return callback.callv([entry.data])
		_problems_cache.erase(key)

	_provider.get_problems(fields, page_size, page, filter, 
		func(problems_data):
			if typeof(problems_data) == TYPE_ARRAY:
				_problems_cache[key] = {
					"data": problems_data,
					"timestamp": Time.get_unix_time_from_system()
				}
			if callback.is_valid():
				callback.callv([problems_data])
	)

func get_wall(uid: String, fields: Array[String], callback: Callable) -> void:
	var key := _build_key([uid, fields])
	if _wall_cache.has(key):
		var entry = _wall_cache[key]
		if not _is_expired(entry.timestamp):
			return callback.callv([entry.data])
		_wall_cache.erase(key)

	_provider.get_wall(uid, fields, 
		func(wall_data):
			if typeof(wall_data) == TYPE_DICTIONARY:
				_wall_cache[key] = {
					"data": wall_data,
					"timestamp": Time.get_unix_time_from_system()
				}
			if callback.is_valid():
				callback.callv([wall_data])
	)

func get_walls(fields: Array[String], page_size: int, page: int, callback: Callable) -> void:
	var key := _build_key([page, page_size, fields])
	if _walls_cache.has(key):
		var entry = _walls_cache[key]
		if not _is_expired(entry.timestamp):
			return callback.call(entry.data)
		_walls_cache.erase(key)

	_provider.get_walls(fields, page_size, page, 
		func(walls_data):
			if typeof(walls_data) == TYPE_ARRAY:
				_walls_cache[key] = {
					"data": walls_data,
					"timestamp": Time.get_unix_time_from_system()
				}
			if callback.is_valid():
				callback.callv([walls_data])
	)

func upsert_problem(problem_data: Dictionary, callback: Callable = Callable()) -> void:
	_provider.upsert_problem(problem_data, 
		func(result):
			_problem_cache.clear()
			_problems_cache.clear()
			if callback.is_valid():
				callback.callv([result])
	)

func upsert_wall(wall_data: Dictionary, callback: Callable = Callable()) -> void:
	_provider.upsert_wall(wall_data, 
		func(result: bool):
			_wall_cache.clear()
			_walls_cache.clear()
			if callback.is_valid():
				callback.callv([result])
	)

# private methods

func _build_key(args: Array) -> String:
	return "|".join(args.map(func(x): return JSON.stringify(x)))

func _init(provider: DataProvider):
	_provider = provider

func _is_expired(timestamp: float) -> bool:
	return Time.get_unix_time_from_system() - timestamp > TTL_SECONDS
