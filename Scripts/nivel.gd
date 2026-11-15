extends Node2D
# Genera basura sobre el suelo del mapa (celdas del TileMapLayer), cerca del jugador,
# mientras haya menos de `max_basuras` en el mapa. Nunca fuera de los limites ni
# pegada al borde.

@onready var player : CharacterBody2D = $player
@export var basuras: Array[PackedScene] = []
@export var intervalo := 3.0
@export var max_basuras := 6
@export var distancia_min := 150.0
@export var distancia_max := 450.0
@export var margen_celdas := 4  # celdas que se dejan libres junto al borde del mapa

var _posiciones_suelo: PackedVector2Array = []

static var aviso_basura_dado := false  # static: sobrevive al cambiar de escena

func _ready():
	# En la luna el traje es obligatorio (cambio de LeJuanChis en 92f9d51).
	# Diferido: este _ready corre antes que el del jugador (esta antes en el arbol),
	# y activar_traje_obligatorio usa nodos que el jugador aun no ha preparado.
	if player != null:
		player.activar_traje_obligatorio.call_deferred()
	else:
		print("ERROR: No se encontró al jugador en Luna")
	if not aviso_basura_dado: # solo la primera vez que entras a la luna
		aviso_basura_dado = true
		Eventos.decir.call_deferred("Recuerda recoger la basura con B.")
	_calcular_suelo()
	var timer := Timer.new()
	timer.wait_time = intervalo
	timer.autostart = true
	timer.timeout.connect(generar_basura)
	add_child(timer)

# Centro global de cada celda del suelo que NO este a menos de `margen_celdas`
# del borde del mapa (se calcula una sola vez).
func _calcular_suelo() -> void:
	var capa := get_node_or_null("TileMapLayer") as TileMapLayer
	if capa == null:
		push_warning("nivel.gd: no hay TileMapLayer, la basura no se generara")
		return
	var celdas := {}
	for celda in capa.get_used_cells():
		celdas[celda] = true
	for celda: Vector2i in celdas:
		if _lejos_del_borde(celda, celdas):
			_posiciones_suelo.append(capa.to_global(capa.map_to_local(celda)))
	if _posiciones_suelo.is_empty():
		push_warning("nivel.gd: margen_celdas demasiado grande, no queda suelo para generar basura")

# true si todas las celdas en un cuadrado de radio `margen_celdas` son suelo.
func _lejos_del_borde(celda: Vector2i, celdas: Dictionary) -> bool:
	for dx in range(-margen_celdas, margen_celdas + 1):
		for dy in range(-margen_celdas, margen_celdas + 1):
			if not celdas.has(celda + Vector2i(dx, dy)):
				return false
	return true

func generar_basura():
	if basuras.is_empty() or _posiciones_suelo.is_empty():
		return
	if get_tree().get_nodes_in_group("basura").size() >= max_basuras:
		return
	# Celdas del suelo dentro del anillo [distancia_min, distancia_max] del jugador.
	var candidatas: Array[Vector2] = []
	for pos in _posiciones_suelo:
		var d := pos.distance_to(player.global_position)
		if d >= distancia_min and d <= distancia_max:
			candidatas.append(pos)
	if candidatas.is_empty():
		return # el jugador esta lejos del suelo util: no se genera nada
	var item: Node2D = basuras.pick_random().instantiate()
	item.add_to_group("basura")
	add_child(item)
	item.global_position = candidatas.pick_random()
