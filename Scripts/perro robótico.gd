extends Node2D

@export var velocidad: float = 450.0
@export var distancia_minima: float = 150.0

@onready var animacion: AnimatedSprite2D = $AnimatedSprite2D

var jugador: Node2D = null


func _ready():
	animacion.play("Idle")


func _physics_process(delta: float) -> void:

	if not is_instance_valid(jugador):
		jugador = get_tree().get_first_node_in_group("player") as Node2D

	if jugador == null:
		animacion.play("Idle")
		return

	var direccion = jugador.global_position - global_position

	if direccion.length() <= distancia_minima:
		animacion.play("Idle")
		return

	var destino = jugador.global_position - direccion.normalized() * distancia_minima

	global_position = global_position.move_toward(
		destino,
		velocidad * delta
	)

	if abs(direccion.x) > abs(direccion.y):

		if direccion.x > 0:
			animacion.play("Der")
		else:
			animacion.play("Izq")

	else:

		if direccion.y > 0:
			animacion.play("Abajo")
		else:
			animacion.play("Arriba")
