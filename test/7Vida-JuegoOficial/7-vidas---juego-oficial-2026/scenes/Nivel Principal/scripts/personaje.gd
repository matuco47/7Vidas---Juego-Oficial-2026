extends CharacterBody2D

@export var velocidad := 200.0
@export var gravedad := 980.0
@export var fuerza_salto := 500.0

var vidas := 7
var tiempo_vida := 60.0

var invencible := false
var siendo_empujado := false
var salto_alto :=false

@onready var tiempo_label = $"../HUD/TiempoLabel"
@onready var VidasControl = $"../HUD/VidasControl"


func _ready():
	actualizar_hud()
	$AudioListener2D.make_current()

	add_to_group("player")
	actualizar_hud()
	$AudioListener2D.make_current()

#hola al que vea estos recordatorios dea

func _physics_process(delta):
	# Grravedad
	if not is_on_floor():
		velocity.y += gravedad * delta

	# Izquierda y Derecha
	if not siendo_empujado:
		var direccion = Input.get_axis("Izquierda", "Derecha")
		velocity.x = direccion * velocidad
		$AnimatedSprite2D.flip_h = direccion<0
	
	salto_alto = false
	if Input.is_action_pressed("Abajo"):
		salto_alto=true

		# Salto con W
	if Input.is_action_just_pressed("Arriba") and is_on_floor():
		if salto_alto:
			velocity.y = -fuerza_salto * 1.5
		else:
			velocity.y = -fuerza_salto

	move_and_slide()

	# Contador de Tiempo de Vida (pobre gato tiene 7 minuto noma)
	tiempo_vida -= delta

	if tiempo_vida <= 0:
		perder_vida()

	actualizar_hud()
	handle_animation()

func handle_animation():
	if velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
	elif salto_alto:
		$AnimatedSprite2D.play("agachado")
	else:
		$AnimatedSprite2D.play("default")
		
func handle_sound():
	if velocity.length() > 0 and is_on_floor() and !$Caminar.is_playing():
		$Caminar.play()
		
		
func perder_vida():
	if vidas <= 0:
		return

	vidas -= 1
	VidasControl.get_child(vidas).visible = false

	if vidas > 0:
		tiempo_vida = 60.0
	else:
		game_over()

func curar() -> void:
	tiempo_vida += 30
	if tiempo_vida >60 and vidas<7:
		VidasControl.get_child(vidas).visible = true
		vidas += 1
		tiempo_vida -= 60
	actualizar_hud()
	$Curar.play()


func recibir_golpe(posicion_enemigo: Vector2, fuerza_empuje: float):
	if invencible or vidas <= 0:
		return

	vidas -= 1
	VidasControl.get_child(vidas).visible = false
	$Dano.play()
	invencible = true
	siendo_empujado = true

	# Hacia q lado te va a empujar el perro
	var direccion_empuje = sign(global_position.x - posicion_enemigo.x)

	if direccion_empuje == 0:
		direccion_empuje = 1

	# Empuje
	velocity.x = direccion_empuje * fuerza_empuje
	velocity.y = -250.0

	actualizar_hud()

	if vidas <= 0:
		game_over()
		return
	
	# No te podes mover por este tiempo
	await get_tree().create_timer(0.25).timeout
	siendo_empujado = false

	# Te volves invulnerable para q no te maten en 3 segundos 5 bichos distintos
	await get_tree().create_timer(0.75).timeout
	invencible = false
	
	


func actualizar_hud():
	tiempo_label.text = "Tiempo: " + str(int(ceil(tiempo_vida)))
	


func game_over():
	tiempo_vida = 0
	velocity = Vector2.ZERO

	actualizar_hud()


	set_physics_process(false)
	
	#Me estoy remplanteando escribir codigo a las 4 am. al q lea esto deme cafe x favor.
