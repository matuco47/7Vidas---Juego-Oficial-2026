extends CharacterBody2D

@export var SPEED = 200
var direction := 1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	velocity.x = direction * SPEED
	$AnimatedSprite2D.flip_h = direction<0
	if !$Caminar.is_playing():
		$Caminar.play()
	
	if is_on_wall():
		direction *= -1
		velocity.x = direction * SPEED
		$Ladra.play()
		
	$AnimatedSprite2D.play("default")

	move_and_slide()
