extends Object
class_name ThreadPool

const MIN_THREADS: int = 1
var _queue: Array = []
var _queue_mutex: Mutex = Mutex.new()
var _running: bool = true
var _running_mutex: Mutex = Mutex.new()
var _threads: Array[Thread] = []

func destroy() -> void:
	print("[Thread: %2s] ThreadPool.destroy ({ \"threads\": %d })" % [OS.get_thread_caller_id(), _threads.size()])
	_running_mutex.lock()
	_running = false
	_running_mutex.unlock()
	for thread in _threads:
		thread.wait_to_finish()
	_threads.clear()
	free()

func request(task: Callable, args: Array = [], callback: Callable = Callable()) -> void:
	var work = { "task": task, "args": args, "callback": callback }
	print("[Thread: %2s] ThreadPool.request (%s)" % [OS.get_thread_caller_id(), work])
	_queue_mutex.lock()
	_queue.append(work)
	_queue_mutex.unlock()

func _init(threads: int) -> void:
	print("[Thread: %2s] ThreadPool._init ({ \"threads\": %d })" % [OS.get_thread_caller_id(), threads])
	for i in range(max(MIN_THREADS, threads)):
		var thread = Thread.new()
		if (thread.start(_process_queue) == OK):
			_threads.append(thread)

func _is_running() -> bool:
	_running_mutex.lock()
	var is_running = _running
	_running_mutex.unlock()
	return is_running

func _process_queue() -> void:
	while (_is_running()):
		_queue_mutex.lock()
		var queue_size = _queue.size()
		var work = _queue.pop_front()
		_queue_mutex.unlock()
		if (work != null):
			print("[Thread: %2s] ThreadPool._process_queue (\"size:\" %s)" % [OS.get_thread_caller_id(), queue_size])
			_process_work(work)
		OS.delay_msec(1)

func _process_work(work: Dictionary) -> void:
	print("[Thread: %2s] ThreadPool._process_work (%s)" % [OS.get_thread_caller_id(), work])
	var results = work.task.callv(work.args)
	call_deferred("_work_done", work.callback, results)

func _work_done(callback: Callable, results) -> void:
	print("[Thread: %2s] ThreadPool._work_done ({ \"callback\": %s })" % [OS.get_thread_caller_id(), callback])
	if callback.is_valid():
		callback.call(results)
