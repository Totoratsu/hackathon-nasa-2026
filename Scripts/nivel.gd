extends Node2D

@onready var player : CharacterBody2D = $player
@export var item_scene: PackedScene

@export var intervalo := 2.0

func _ready():
	var timer=Timer.new()
	timer.wait_time = intervalo
	timer.autostart = true
	timer.timeout.connect(generar_item)
	add_child(timer)

func generar_item():
	var item = item_scene.instantiate()
	var offset = Vector2.from_angle(randf() * TAU) * randf_range(100, 300)
	item.global_position = player.global_position + offset
	add_child(item)
	item.body_entered.connect(_on_item_body_entered)

func _on_item_body_entered(body: Node2D):
	if body.is_in_group("player"):
		Eventos.sumar_dinero(1)
