extends CharacterBody2D

const velocidad = 350
@onready var animacion = $AnimatedSprite2D
var traje = false

func _ready():
	add_to_group("player")
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("traje"):
		traje = !traje
	
	if Input.is_action_pressed("izquierda"):
		position.x -= velocidad * _delta
		if traje: animacion.play("astronauta izq")
		else: animacion.play("Izq")
	elif Input.is_action_pressed("derecha"):
		position.x += velocidad * _delta
		if traje: animacion.play("astronauta der")
		else: animacion.play("Der")
	elif Input.is_action_pressed("arriba"):
		position.y -= velocidad * _delta
		if traje: animacion.play("astronauta arriba")
		else: animacion.play("Arriba")
	elif Input.is_action_pressed("abajo"):
		position.y += velocidad * _delta
		if traje: animacion.play("astronauta abajo")
		else: animacion.play("Abajo")
	else:
		if traje: animacion.play("astronauta idle")
		else: animacion.play("Idle")
	
	move_and_slide()
