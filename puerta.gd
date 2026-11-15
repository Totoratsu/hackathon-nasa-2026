extends Area2D

# Ruta en texto (no PackedScene) para evitar la referencia ciclica luna <-> nave.
@export_file("*.tscn") var escena: String
@export var revisar_traje := false  # activado solo en la puerta para salir de la nave

func _on_body_entered(_body: Node2D):
	if revisar_traje and not Eventos.puede_salir():
		print("Tu traje no aguanta este clima")
		return
	get_tree().change_scene_to_file(escena)
