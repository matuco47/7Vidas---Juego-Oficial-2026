extends Control


@onready var hover_sound: AudioStreamPlayer = $VBoxContainer/HoverSound
@onready var confirm_sound: AudioStreamPlayer = $VBoxContainer/ConfirmSound
@onready var back_sound: AudioStreamPlayer = $VBoxContainer/BackSound

@onready var play_button: TextureButton = $VBoxContainer/PlayButton
@onready var options_button: TextureButton = $VBoxContainer/OptionsButton
@onready var credits_button: TextureButton = $VBoxContainer/CreditsButton
@onready var exit_button: TextureButton = $VBoxContainer/ExitButton


func _ready() -> void:
	play_button.mouse_entered.connect(_on_button_hover)
	options_button.mouse_entered.connect(_on_button_hover)
	credits_button.mouse_entered.connect(_on_button_hover)
	exit_button.mouse_entered.connect(_on_button_hover)


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
# JUGAR
# ==========================================

func _on_play_button_pressed() -> void:
	_play_confirm_sound()

	get_tree().change_scene_to_file(
		"res://scenes/Menu Principal/Scenes/loading_screen.tscn")


# ==========================================
# OPCIONES
# ==========================================

func _on_options_button_pressed() -> void:
	_play_confirm_sound()

	get_tree().change_scene_to_file(
		"res://scenes/Menu Principal/Scenes/options_menu.tscn"
	)


# ==========================================
# CRÉDITOS
# ==========================================

func _on_credits_button_pressed() -> void:
	_play_confirm_sound()

	get_tree().change_scene_to_file(
		"res://scenes/Menu Principal/Scenes/credits.tscn"
	)


# ==========================================
# SALIR
# ==========================================

func _on_exit_button_pressed() -> void:
	_play_back_sound()
	get_tree().quit()
