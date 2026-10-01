extends Control


@onready var hover_sound: AudioStreamPlayer = $VBoxContainer/HoverSound
@onready var confirm_sound: AudioStreamPlayer = $VBoxContainer/ConfirmSound
@onready var back_sound: AudioStreamPlayer = $VBoxContainer/BackSound

@onready var volume_slider: HSlider = $VBoxContainer/VolumenSlider
@onready var check_box: CheckBox = $VBoxContainer/CheckBox
@onready var exit_options: TextureButton = $VBoxContainer/ExitOptions


func _ready() -> void:
	# Sonido hover
	check_box.mouse_entered.connect(_on_button_hover)
	exit_options.mouse_entered.connect(_on_button_hover)

	# Recuperar volumen guardado
	volume_slider.set_value_no_signal(
		Settings.master_volume
	)

	# Aplicar volumen guardado
	_apply_volume(Settings.master_volume)

	# Comprobar si ya estamos en fullscreen
	var is_fullscreen := (
		DisplayServer.window_get_mode()
		== DisplayServer.WINDOW_MODE_FULLSCREEN
	)

	# Actualizar checkbox sin ejecutar la señal
	check_box.set_pressed_no_signal(is_fullscreen)


# ==========================================
# SONIDOS
# ==========================================

func _on_button_hover() -> void:
	hover_sound.play()


func _play_confirm_sound() -> void:
	confirm_sound.play()


func _play_back_sound() -> void:
	back_sound.play()


# ==========================================
# VOLUMEN
# ==========================================

func _on_volumen_slider_value_changed(value: float) -> void:
	Settings.master_volume = value

	_apply_volume(value)


func _apply_volume(value: float) -> void:
	var master_bus := AudioServer.get_bus_index("Master")

	if master_bus == -1:
		push_error("No se encontró el bus Master.")
		return

	if value <= 0.0:
		AudioServer.set_bus_mute(
			master_bus,
			true
		)

	else:
		AudioServer.set_bus_mute(
			master_bus,
			false
		)

		AudioServer.set_bus_volume_db(
			master_bus,
			linear_to_db(value / 100.0)
		)


# ==========================================
# FULLSCREEN
# ==========================================

func _on_check_box_toggled(toggled_on: bool) -> void:
	_play_confirm_sound()

	if toggled_on:
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_FULLSCREEN
		)

	else:
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_WINDOWED
		)


# ==========================================
# VOLVER AL MENÚ
# ==========================================

func _on_exit_options_pressed() -> void:
	_play_back_sound()

	get_tree().change_scene_to_file(
		"res://scenes/Menu Principal/Scenes/main_menu.tscn"
	)
