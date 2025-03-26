extends MarginContainer

@onready var labelOk = $VBoxContainer/Control/MarginContainer/Scroll/Lista/CenterContainer/LabelOk
@onready var lineEditIP = $VBoxContainer/Control/MarginContainer/Scroll/Lista/HBoxContainer/LineEditIP
@onready var fontRadio = $VBoxContainer/Control/MarginContainer/Scroll/Lista/HBoxContainer2/CheckBoxFont
@onready var huecoRadio = $VBoxContainer/Control/MarginContainer/Scroll/Lista/HBoxContainer2/CheckBoxHueco

func _ready() -> void:
	lineEditIP.text = AppManager.wall_ip
	if AppManager.grade_system == Grade.GRADE_SYSTEMS.FONT:
		fontRadio.button_pressed = true
	else:
		huecoRadio.button_pressed = true
		

func _on_panel_save_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		AppManager.wall_ip = lineEditIP.text
		AppManager.save_config()
		# show and hide config saved text
		labelOk.text = "Config Saved"
		var timer := Timer.new()
		add_child(timer)
		timer.wait_time = 2.0
		timer.one_shot = true
		timer.connect("timeout", _on_timer_timeout)
		timer.start()
		
func _on_timer_timeout() -> void:
	labelOk.text = ""

func _on_button_problems_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)

func _on_button_walls_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.WALL_LIST, null)

func _on_button_config_pressed() -> void:
	pass # Replace with function body.

func _on_check_box_font_pressed() -> void:
	AppManager.grade_system = Grade.GRADE_SYSTEMS.FONT
	
func _on_check_box_hueco_pressed() -> void:
	AppManager.grade_system = Grade.GRADE_SYSTEMS.HUECO
