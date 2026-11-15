extends Area2D

@export_file("*.tscn") var escena_destino: String
@export var requiere_traje: bool = true

var teletransportando: bool = false


func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if teletransportando:
		return

	if not body.is_in_group("player"):
		return

	# Comprobar si el portal exige llevar el traje
	if requiere_traje and body.get("traje") != true:
		print("¡Necesitas el traje para entrar!")
		return

	# Comprobar el destino
	if escena_destino.is_empty():
		push_error("ERROR: No hay escena de destino")
		return

	teletransportando = true

	print("Teletransportando a: ", escena_destino)

	get_tree().call_deferred(
		"change_scene_to_file",
		escena_destino
	)
