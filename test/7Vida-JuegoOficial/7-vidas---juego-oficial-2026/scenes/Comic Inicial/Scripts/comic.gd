extends Node2D


@onready var camera: Camera2D = $Camera2D

@onready var panel_1: Marker2D = $CameraPoints/Panel1
@onready var panel_2: Marker2D = $CameraPoints/Panel2
@onready var panel_3: Marker2D = $CameraPoints/Panel3
@onready var panel_4: Marker2D = $CameraPoints/Panel4
@onready var panel_5: Marker2D = $CameraPoints/Panel5
@onready var panel_6: Marker2D = $CameraPoints/Panel6
@onready var panel_7: Marker2D = $CameraPoints/Panel7


var current_panel: int = 0
var changing_panel: bool = false

var panels: Array[Marker2D]


var panel_zooms := [
	Vector2(1.5, 1.5), # Panel 1
	Vector2(1.5, 1.5), # Panel 2
	Vector2(1.2, 1.2), # Panel 3
	Vector2(1.4, 1.4), # Panel 4
	Vector2(1.4, 1.4), # Panel 5
	Vector2(1.4, 1.4), # Panel 6
	Vector2(1.4, 1.4)  # Panel 7
]


func _ready() -> void:
	panels = [
		panel_1,
		panel_2,
		panel_3,
		panel_4,
		panel_5,
		panel_6,
		panel_7
	]

	# Empezar directamente en la primera viñeta
	camera.global_position = panels[0].global_position
	camera.zoom = panel_zooms[0]


func _process(_delta: float) -> void:
	# Avanzar con Enter o Space
	if Input.is_action_just_pressed("ui_accept"):
		next_panel()

	# Avanzar con click izquierdo
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		next_panel()


func next_panel() -> void:
	if changing_panel:
		return

	current_panel += 1

	# Terminamos el cómic
	if current_panel >= panels.size():
		finish_comic()
		return

	move_camera_to_panel(current_panel)


func move_camera_to_panel(index: int) -> void:
	changing_panel = true

	var target := panels[index]

	var tween := create_tween()

	tween.set_parallel(true)

	# Mover cámara
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

	# Cambiar zoom
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
		"res://scenes/Nivel Principal/levels/zona1.tscn"
	)
