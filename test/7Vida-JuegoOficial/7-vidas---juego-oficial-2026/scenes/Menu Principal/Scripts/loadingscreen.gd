extends Node2D


const NEXT_SCENE := "res://scenes/Comic Inicial/comic.tscn"
const LOADING_TIME := 3.0


func _ready() -> void:
	print("Pantalla de carga iniciada")

	await get_tree().create_timer(LOADING_TIME).timeout

	print("Carga terminada. Entrando al cómic...")

	get_tree().change_scene_to_file(NEXT_SCENE)
