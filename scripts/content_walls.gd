extends Control


@onready var lista = $Scroll/Lista
@onready var card = preload("res://components/wall_card.tscn")

var load_thread := Thread.new()

#const Wall = preload("res://scripts/Wall.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# delete cards
	for child in lista.get_children():
		child.queue_free()

	# load walls
	load_thread.start(Callable(self, "_load_walls_async"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_button_problems_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)

func _on_button_walls_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.WALL_LIST, null)

func _on_panel_add_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		AppManager.load_screen(AppManager.Screen.WALL_EDIT, null)

func _on_button_config_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.CONFIG, null)
	
func _load_walls_async():
	call_deferred("_on_walls_loaded", Database.get_db_walls())
	
func _on_walls_loaded(walls):
	for w in walls:
		var c = card.instantiate()
		c.load_data(w)
		lista.add_child(c)
	load_thread.wait_to_finish()
