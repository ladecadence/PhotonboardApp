extends MarginContainer

@onready var window : Window = get_window()

func _ready() -> void:
	var os = OS.get_name()
	if os == "Android" || os ==  "iOS":
		var safe_area  = DisplayServer.get_display_safe_area()
		var window_size = window.size

		# SET BASE MARGINS (THE ONES YOU HAVE CURRENTLY IN YOUR MARGIN CONTAINER
		var top= 0
		var left = 0
		var bottom = 0
		var right = 0

		# CALQULATE EXTRA PADDING REQUIRED TO SKIP NOTCH
		if window_size.x >= safe_area.size.x and window_size.y >= safe_area.size.y:
			var x_factor = float(safe_area.size.x) / float(window_size.x)
			var y_factor = float(safe_area.size.y) / float(window_size.y)

			top = max(top, safe_area.position.y * y_factor)
			left = max(left, safe_area.position.x * x_factor)
			bottom = max(bottom, abs(safe_area.end.y - window_size.y) * y_factor)
			right = max(right, abs(safe_area.end.x - window_size.x) * x_factor)

		# OVERRIDE MARGIN CONTAINER (HOSTS THIS SCRIPT)
		add_theme_constant_override("margin_top",top)
		add_theme_constant_override("margin_left",left)
		add_theme_constant_override("margin_right",right)
		add_theme_constant_override("margin_bottom",bottom)
