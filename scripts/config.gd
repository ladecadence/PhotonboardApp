extends MarginContainer

@onready var labelOk = $VBoxContainer/Control/MarginContainer/Scroll/Lista/CenterContainer/LabelOk
@onready var lineEditIP = $VBoxContainer/Control/MarginContainer/Scroll/Lista/HBoxContainer/LineEditIP
@onready var fontRadio = $VBoxContainer/Control/MarginContainer/Scroll/Lista/HBoxContainer2/CheckBoxFont
@onready var huecoRadio = $VBoxContainer/Control/MarginContainer/Scroll/Lista/HBoxContainer2/CheckBoxHueco
@onready var dataSourceOptionButton = $VBoxContainer/Control/MarginContainer/Scroll/Lista/HBoxContainerDataSource/DataSourceOptionButton

var _data_source: AppManager.DataSource = AppManager.DataSource.LOCAL

func _ready() -> void:
	$VBoxContainer/Header2.set_title("Config")
	lineEditIP.text = AppManager.wall_ip
	if AppManager.grade_system == Grade.GRADE_SYSTEMS.FONT:
		fontRadio.button_pressed = true
	else:
		huecoRadio.button_pressed = true
	dataSourceOptionButton.selected = AppManager.data_source

func _on_panel_save_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		AppManager.wall_ip = lineEditIP.text
		AppManager.data_source = dataSourceOptionButton.selected
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

func _on_check_box_font_pressed() -> void:
	AppManager.grade_system = Grade.GRADE_SYSTEMS.FONT
	
func _on_check_box_hueco_pressed() -> void:
	AppManager.grade_system = Grade.GRADE_SYSTEMS.HUECO
