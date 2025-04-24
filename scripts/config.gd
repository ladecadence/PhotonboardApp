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

func _on_option_button_data_source_item_selected(index: int) -> void:
	_update_connection_container_visibility(index)

func _on_panel_save_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_update_config(AppManager.config)
		AppManager.config.save()
		AppManager.update_data_source()

		# show and hide config saved text
		_okLabel.text = "Config Saved"
		var timer := Timer.new()
		add_child(timer)
		timer.wait_time = 2.0
		timer.one_shot = true
		timer.connect("timeout", _on_save_timer_timeout)
		timer.start()

func _on_save_timer_timeout() -> void:
	_okLabel.text = ""

func _ready() -> void:
	$VBoxContainer/Header2.set_title("Config")
	_tabContainer.set_tab_title(0, "Wall")
	_tabContainer.set_tab_title(1, "Data")
	_update_screen_data(AppManager.config)
	_update_connection_container_visibility(AppManager.config.data_source)

func _update_config(config: Config) -> void:
	config.cloud_url = _urlLineEdit.text
	config.cloud_user = _userLineEdit.text
	config.cloud_password = _passwordLineEdit.text
	config.data_source = _dataSourceOptionButton.selected
	if _fontRadio.button_pressed:
		config.grade_system = Grade.GRADE_SYSTEMS.FONT
	elif _huecoRadio.button_pressed:
		config.grade_system = Grade.GRADE_SYSTEMS.HUECO
	config.wall_ip = _ipLineEdit.text

func _update_connection_container_visibility(data_source: Config.DataSource) -> void:
	if data_source == Config.DataSource.LOCAL:
		_connectionContainer.visible = false
	elif data_source == Config.DataSource.CLOUD:
		_connectionContainer.visible = true
		
func _update_screen_data(config: Config) -> void:
	_urlLineEdit.text = config.cloud_url
	_userLineEdit.text = config.cloud_user
	_passwordLineEdit.text = config.cloud_password
	_dataSourceOptionButton.selected = config.data_source
	if Grade.GRADE_SYSTEMS.FONT == config.grade_system:
		_fontRadio.button_pressed = true
	elif Grade.GRADE_SYSTEMS.HUECO == config.grade_system:
		_huecoRadio.button_pressed = true
	_ipLineEdit.text = config.wall_ip
