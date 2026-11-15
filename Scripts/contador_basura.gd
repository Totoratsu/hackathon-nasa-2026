extends Label
# Muestra "recogida/5" mientras la mision de basura esta en curso.
# Se usa tanto en la luna como en la nave; lee todo de Eventos.

func _ready() -> void:
	add_to_group("ocultar_en_misiones")
	_actualizar()
	Eventos.basura_recogida.connect(func(_c: int): _actualizar())
	Eventos.mesa_investigacion.connect(func(_d: bool): _actualizar())

func _actualizar() -> void:
	if Eventos.mesa_disponible: # mision ya completada
		text = ""
	else:
		text = "%d/%d" % [Eventos.basura_recogida_total, Eventos.BASURA_MISION_1]
