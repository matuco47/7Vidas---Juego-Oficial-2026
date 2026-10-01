extends Node2D


@onready var camera: Camera2D = $Camera2D

@onready var panel_1: Marker2D = $CameraPoints/Panel1
@onready var panel_2: Marker2D = $CameraPoints/Panel2


var current_panel: int = 0
var changing_panel: bool = false

var panels: Array[Marker2D]


var panel_zooms := [
	Vector2(1.5, 1.5), # Viñeta 1
	Vector2(0.8, 0.8)  # Viñeta final grande
]


func _ready() -> void:
	panels = [
		panel_1,
		panel_2
	]

	# Empezar en la primera viñeta
	camera.global_position = panels[0].global_position
	camera.zoom = panel_zooms[0]


func _input(event: InputEvent) -> void:
	# Enter / Space
	if event.is_action_pressed("ui_accept"):
		next_panel()

	# Click izquierdo
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			next_panel()


func next_panel() -> void:
	if changing_panel:
		return

	current_panel += 1

	# Terminamos el cómic final
	if current_panel >= panels.size():
		finish_comic()
		return

	move_camera_to_panel(current_panel)


func move_camera_to_panel(index: int) -> void:
	changing_panel = true

	var target := panels[index]

	var tween := create_tween()

	tween.set_parallel(true)

	# Movimiento de cámara
	tween.tween_property(
		camera,
		"global_position",
		target.global_position,
		1.2
	).set_trans(
		Tween.TRANS_QUAD
	).set_ease(
		Tween.EASE_IN_OUT
	)

	# Zoom
	tween.tween_property(
		camera,
		"zoom",
		panel_zooms[index],
		1.2
	).set_trans(
		Tween.TRANS_QUAD
	).set_ease(
		Tween.EASE_IN_OUT
	)

	tween.set_parallel(false)

	tween.tween_callback(
		func():
			changing_panel = false
	)


func finish_comic() -> void:
	get_tree().change_scene_to_file(
		"res://scenes/Menu Principal/Scenes/credits.tscn"
	)
