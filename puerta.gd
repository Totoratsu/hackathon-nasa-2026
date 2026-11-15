extends Area2D

# Ruta en texto (no PackedScene) para evitar la referencia ciclica luna <-> nave.
@export_file("*.tscn") var escena: String

func _on_body_entered(_body: Node2D):
	get_tree().change_scene_to_file(escena)
