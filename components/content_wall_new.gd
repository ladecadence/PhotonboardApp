extends Control

@onready var file_dialog = $FileDialog
@onready var name_in = $MarginContainer/Scroll/Lista/HBoxContainer/LineEditName
@onready var description_in = $MarginContainer/Scroll/Lista/HBoxContainer2/TextEdit
@onready var max_in = $MarginContainer/Scroll/Lista/HBoxContainer6/SpinBoxMax
@onready var min_in = $MarginContainer/Scroll/Lista/HBoxContainer4/SpinBoxMin
@onready var adjustable_in = $MarginContainer/Scroll/Lista/HBoxContainer3/CheckBoxAdjustable

var image: Image
var image_loaded: bool = false

func _ready() -> void:
	file_dialog.add_filter("*.jpg", "JPG images")
	file_dialog.file_mode = FileDialog.FileMode.FILE_MODE_OPEN_FILE

func _on_panel_cancel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Back to wall list
		AppManager.load_screen(AppManager.Screen.WALL_LIST, null)


func _on_panel_continue_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# check values
		if name_in.text == "" or description_in.text == "" or (adjustable_in.button_pressed and (min_in.value == max_in.value or min_in.value > max_in.value)):
			$MarginContainer/Scroll/Lista/HBoxContainer8/LabelInfo.text = "Please fill all the fields with correct values."
		elif not image_loaded:
			$MarginContainer/Scroll/Lista/HBoxContainer8/LabelInfo.text = "Please select a JPG image for the wall."
		else:
			# continue to edit wall holds
			# var wall = Database.get_db_wall("1fddf17c-3ddf-4dc7-a3d0-e3ac3d9f8b05")
			var wall = Wall.new(null, name_in.text, description_in.text, adjustable_in.button_pressed, min_in.value, max_in.value, image, image.get_width(), image.get_height())
			AppManager.load_screen(AppManager.Screen.WALL_EDIT_HOLDS, wall)

func _on_button_open_image_pressed() -> void:
	file_dialog.show()

func _on_file_dialog_file_selected(path: String) -> void:
	print("Image: ", path)
	image = Image.load_from_file(path)
	if image == null:
		image_loaded = false
	else:
		# resize maximun 1000px big side
		var imgx = image.get_width()
		var imgy = image.get_height()
		var ratio: float
		print("Image: ", imgx, ", ", imgy)
		if imgx > 1000 or imgy > 1000:
			if imgx > imgy:
				ratio = float(imgx)/float(imgy)
				image.resize(1000, 1000*ratio,Image.INTERPOLATE_BILINEAR)
			else:
				ratio = float(imgy)/float(imgx)
				image.resize(1000*ratio, 1000, Image.INTERPOLATE_BILINEAR)
			imgx = image.get_width()
			imgy = image.get_height()
			print("Ratio: ", ratio)
			print("Image resized: ", imgx, ", ", imgy)
		image_loaded = true

func _on_button_config_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.CONFIG, null)


func _on_button_walls_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.WALL_LIST, null)


func _on_button_problems_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)
