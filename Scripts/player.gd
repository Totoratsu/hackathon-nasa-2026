
extends CharacterBody2D

@onready var barra_oxigeno: TextureProgressBar = $CanvasLayer/TextureProgressBar
@onready var animacion = $AnimatedSprite2D

@export var max_oxigeno: float = 100.0
@export var consumo_por_segundo: float = 5.0

var oxigeno_actual: float = 100.0
const velocidad = 350
var traje = false


func _ready():
	oxigeno_actual = max_oxigeno

	barra_oxigeno.min_value = 0.0
	barra_oxigeno.max_value = max_oxigeno
	barra_oxigeno.value = oxigeno_actual

	add_to_group("player")


func _process(delta: float):
	# Activar o desactivar el traje
	if Input.is_action_just_pressed("traje"):
		traje = !traje

	# Consumir oxigeno mientras el traje esta activo
	if traje:
		disminuir_oxigeno(delta)

	# Actualizar visualmente la barra
	barra_oxigeno.value = oxigeno_actual

	# Comprobar si se agoto el oxigeno
	if oxigeno_actual <= 0.0:
		morir_por_asfixia()


func disminuir_oxigeno(delta: float):
	if oxigeno_actual > 0.0:
		oxigeno_actual -= consumo_por_segundo * delta
		oxigeno_actual = maxf(oxigeno_actual, 0.0)


func morir_por_asfixia():
	set_process(false)
	print("¡Te has quedado sin oxígeno!")
	get_tree().change_scene_to_file("res://escenas/game over.tscn")


func _physics_process(_delta):
	if Input.is_action_pressed("izquierda"):
		position.x -= velocidad * _delta
		if traje:
			animacion.play("astronauta izq")
		else:
			animacion.play("Izq")

	elif Input.is_action_pressed("derecha"):
		position.x += velocidad * _delta
		if traje:
			animacion.play("astronauta der")
		else:
			animacion.play("Der")

	elif Input.is_action_pressed("arriba"):
		position.y -= velocidad * _delta
		if traje:
			animacion.play("astronauta arriba")
		else:
			animacion.play("Arriba")

	elif Input.is_action_pressed("abajo"):
		position.y += velocidad * _delta
		if traje:
			animacion.play("astronauta abajo")
		else:
			animacion.play("Abajo")

	else:
		if traje:
			animacion.play("astronauta idle")
		else:
			animacion.play("Idle")

	move_and_slide()
