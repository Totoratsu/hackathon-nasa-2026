extends Area2D

@export var escena: PackedScene

func _on_body_entered(_body: Node2D):
	get_tree().change_scene_to_packed(escena)
