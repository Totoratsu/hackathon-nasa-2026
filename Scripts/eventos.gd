extends Node

signal basura_recogida(cantidad: int)
signal mesa_investigacion(mesa_disponible: bool)

# Estado que sobrevive a los cambios de escena (luna <-> nave).
var mesa_disponible := false

func _ready() -> void:
	mesa_investigacion.connect(func(disponible: bool): mesa_disponible = disponible)
