extends Area2D


@export var comic_final: PackedScene

var activado := false


func _on_body_entered(body: Node2D) -> void:
	print("Entró al trigger: ", body.name)

	if activado:
		return

	if body.is_in_group("player"):
		print("Jugador detectado. Cambiando al Comic Final.")

		activado = true

		if comic_final == null:
			push_error("No asignaste la escena Comic Final en el Inspector.")
			activado = false
			return

		get_tree().change_scene_to_packed(comic_final)
