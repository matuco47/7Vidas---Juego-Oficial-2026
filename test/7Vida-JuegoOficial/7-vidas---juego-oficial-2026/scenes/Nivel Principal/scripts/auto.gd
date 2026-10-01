extends Area2D
@export var fuerza_empuje := 500.0
@export var state = 1
var contacto = false
var bodyGlobal = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("lejos")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if contacto and bodyGlobal != null:
		bodyGlobal.recibir_golpe(global_position, fuerza_empuje)
	
func _on_body_entered(body):
	if body.has_method("recibir_golpe"):
		bodyGlobal = body


func _on_animated_sprite_2d_animation_looped() -> void:
	state += 1
	if state == 1:
		self.visible = true
		$AnimatedSprite2D.play("lejos")
	if state == 2:
		$AnimatedSprite2D.play("acercando")
	if state == 3:
		$AnimatedSprite2D.play("contacto")
		$Pasando.play()
		contacto = true
	if state >= 4:
		self.visible = false
		contacto = false
		$AnimatedSprite2D.play("lejos")
		state = 0


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("recibir_golpe"):
		bodyGlobal = null
