extends Node2D


# ==========================================
# NODOS
# ==========================================

@onready var camera: Camera2D = $Camera2D
@onready var camera_points: Node2D = $CameraPoints

@onready var exit_credits: TextureButton = $UI/VBoxContainer/ExitCredits

@onready var hover_sound: AudioStreamPlayer = $UI/VBoxContainer/HoverSound
@onready var confirm_sound: AudioStreamPlayer = $UI/VBoxContainer/ConfirmSound
@onready var back_sound: AudioStreamPlayer = $UI/VBoxContainer/BackSound


# ==========================================
# VARIABLES
# ==========================================

var points: Array[Node2D] = []

var current_point: int = 0
var camera_moving: bool = false

const CAMERA_MOVE_TIME: float = 1.0
const CAMERA_ZOOM := Vector2(1.0, 1.0)


# ==========================================
# READY
# ==========================================

func _ready() -> void:
	# Mantener música del menú.
	MenuMusic.play_menu_music()

	# Sonido al pasar el mouse por Volver.
	exit_credits.mouse_entered.connect(
		_on_button_hover
	)

	# Obtener automáticamente todos los Marker2D
	# que estén dentro de CameraPoints.
	for child in camera_points.get_children():
		if child is Marker2D:
			points.append(child)

	# Comprobar que realmente existan puntos.
	if points.is_empty():
		push_error(
			"No hay Marker2D dentro de CameraPoints."
		)
		return

	# Empezar directamente en el primer punto.
	camera.global_position = points[0].global_position
	camera.zoom = CAMERA_ZOOM


# ==========================================
# CLICK PARA AVANZAR
# ==========================================

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (
			event.button_index == MOUSE_BUTTON_LEFT
			and event.pressed
		):
			next_point()


# ==========================================
# SIGUIENTE PUNTO
# ==========================================

func next_point() -> void:
	# No aceptar más clicks mientras
	# la cámara se está moviendo.
	if camera_moving:
		return

	current_point += 1

	# Cuando lleguemos al último punto,
	# simplemente nos quedamos ahí.
	if current_point >= points.size():
		current_point = points.size() - 1
		return

	move_camera_to_point(current_point)


# ==========================================
# MOVER CÁMARA
# ==========================================

func move_camera_to_point(index: int) -> void:
	camera_moving = true

	var target_position := points[index].global_position

	var tween := create_tween()

	tween.tween_property(
		camera,
		"global_position",
		target_position,
		CAMERA_MOVE_TIME
	).set_trans(
		Tween.TRANS_QUAD
	).set_ease(
		Tween.EASE_IN_OUT
	)

	tween.finished.connect(
		_on_camera_movement_finished
	)


func _on_camera_movement_finished() -> void:
	camera_moving = false


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
# VOLVER AL MENÚ PRINCIPAL
# ==========================================

func _on_exit_credits_pressed() -> void:
	_play_back_sound()

	get_tree().change_scene_to_file(
		"res://scenes/Menu Principal/Scenes/main_menu.tscn"
	)
