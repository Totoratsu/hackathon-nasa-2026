extends Node2D
# Genera basura alrededor del jugador mientras haya menos de `max_basuras` en el mapa.

@onready var player : CharacterBody2D = $player
@export var basuras: Array[PackedScene] = []
@export var intervalo := 3.0
@export var max_basuras := 6
@export var distancia_min := 150.0
@export var distancia_max := 450.0

func _ready():
	var timer := Timer.new()
	timer.wait_time = intervalo
	timer.autostart = true
	timer.timeout.connect(generar_basura)
	add_child(timer)

func generar_basura():
	if basuras.is_empty() or get_tree().get_nodes_in_group("basura").size() >= max_basuras:
		return
	var item: Node2D = basuras.pick_random().instantiate()
	item.add_to_group("basura")
	var offset := Vector2.from_angle(randf() * TAU) * randf_range(distancia_min, distancia_max)
	item.global_position = player.global_position + offset
	add_child(item)
