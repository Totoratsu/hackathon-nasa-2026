extends CharacterBody2D

const velocidad = 350
@onready var animacion = $AnimatedSprite2D

func _ready():
	add_to_group("player")

func _physics_process(_delta):
	
	if Input.is_action_pressed("izquierda"):
		position.x -= velocidad * _delta
		animacion.play("Izq")
	elif Input.is_action_pressed("derecha"):
		position.x += velocidad * _delta
		animacion.play("Der")
	elif Input.is_action_pressed("arriba"):
		position.y -= velocidad * _delta
		animacion.play("Arriba")
	elif Input.is_action_pressed("abajo"):
		position.y += velocidad * _delta
		animacion.play("Abajo")
	else:
		animacion.play("Idle")
	
	move_and_slide()
