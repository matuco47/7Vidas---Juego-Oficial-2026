extends Area2D
#basicamente el funcionamiento del perro y de posiblemente todos los enemigos q hayan.
@export var fuerza_empuje := 500.0


func _on_body_entered(body):
	if body.has_method("recibir_golpe"):
		body.recibir_golpe(global_position, fuerza_empuje)

#ola chabo
