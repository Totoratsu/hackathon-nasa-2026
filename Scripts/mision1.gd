extends Node2D

func _ready() -> void:
	Eventos.basura_recogida.connect(_on_basura_recogida)

func _on_basura_recogida(cantidad: int) -> void:
	if Eventos.mesa_disponible: # mision ya completada
		return
	print("Llevas ", cantidad)
	if cantidad == Eventos.BASURA_MISION_1:
		Eventos.mesa_investigacion.emit(true)
		print("¡Misión de basura completa!") # aquí va lo que quieras que pase
