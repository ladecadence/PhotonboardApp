extends MarginContainer

# private components

@onready var _fontRadio = $VBoxContainer/Control/TopContainer/TabContainer/WallContainer/MarginContainer/VBoxContainer/GradeContainer/CheckBoxFont
@onready var _huecoRadio = $VBoxContainer/Control/TopContainer/TabContainer/WallContainer/MarginContainer/VBoxContainer/GradeContainer/CheckBoxHueco
@onready var _ipLineEdit = $VBoxContainer/Control/TopContainer/TabContainer/WallContainer/MarginContainer/VBoxContainer/IPContainer/LineEditIP
@onready var _okLabel = $VBoxContainer/Control/BottomContainer/VBoxContainer/LabelContainer/OkLabel

@onready var _connectionContainer = $VBoxContainer/Control/TopContainer/TabContainer/DataSourceContainer/MarginContainer/VBoxContainer/ConnectionContainer
@onready var _dataSourceOptionButton = $VBoxContainer/Control/TopContainer/TabContainer/DataSourceContainer/MarginContainer/VBoxContainer/ProviderContainer/ProviderOptionButton
@onready var _passwordLineEdit = $VBoxContainer/Control/TopContainer/TabContainer/DataSourceContainer/MarginContainer/VBoxContainer/ConnectionContainer/PasswordContainer/PasswordLineEdit
@onready var _urlLineEdit = $VBoxContainer/Control/TopContainer/TabContainer/DataSourceContainer/MarginContainer/VBoxContainer/ConnectionContainer/URLContainer/URLLineEdit
@onready var _userLineEdit = $VBoxContainer/Control/TopContainer/TabContainer/DataSourceContainer/MarginContainer/VBoxContainer/ConnectionContainer/UserContainer/UserLineEdit

@onready var _tabContainer = $VBoxContainer/Control/TopContainer/TabContainer

# private methods

func _ready() -> void:
	$VBoxContainer/Header2.set_title("Config")

	_tabContainer.set_tab_title(0, "Wall")
	_tabContainer.set_tab_title(1, "Data")

	_ipLineEdit.text = AppManager.wall_ip
	if AppManager.grade_system == Grade.GRADE_SYSTEMS.FONT:
		_fontRadio.button_pressed = true
	else:
		_huecoRadio.button_pressed = true
	_setDataSource(AppManager.data_source)

func _on_panel_save_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		AppManager.wall_ip = _ipLineEdit.text
		AppManager.data_source = _dataSourceOptionButton.selected
		AppManager.save_config()
		# show and hide config saved text
		_okLabel.text = "Config Saved"
		var timer := Timer.new()
		add_child(timer)
		timer.wait_time = 2.0
		timer.one_shot = true
		timer.connect("timeout", _on_timer_timeout)
		timer.start()
		
func _on_timer_timeout() -> void:
	_okLabel.text = ""

func _on_check_box_font_pressed() -> void:
	AppManager.grade_system = Grade.GRADE_SYSTEMS.FONT
	
func _on_check_box_hueco_pressed() -> void:
	AppManager.grade_system = Grade.GRADE_SYSTEMS.HUECO

func _on_option_button_data_source_item_selected(index: int) -> void:
	_setDataSource(index)

func _setDataSource(data_source: AppManager.DataSource) -> void:
	_dataSourceOptionButton.selected = data_source
	if data_source == AppManager.DataSource.LOCAL:
		_connectionContainer.visible = false
	elif data_source == AppManager.DataSource.CLOUD:
		_connectionContainer.visible = true
