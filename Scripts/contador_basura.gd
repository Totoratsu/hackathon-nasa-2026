extends Label
# Muestra "recogida/5" mientras la mision de basura esta en curso.
# Se usa tanto en la luna como en la nave; lee todo de Eventos.

const ICONO := preload("res://Sprites/sprites mesa de trabajo.png")
const TAM_ICONO := 48

var icono := TextureRect.new()

func _ready() -> void:
	# Bote de basura del atlas, centrado encima del contador.
	var bote := AtlasTexture.new()
	bote.atlas = ICONO
	bote.region = Rect2(0, 19, 81, 87)
	icono.texture = bote
	icono.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icono.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icono.custom_minimum_size = Vector2(TAM_ICONO, TAM_ICONO)
	icono.size = Vector2(TAM_ICONO, TAM_ICONO)
	icono.position = Vector2((size.x - TAM_ICONO) / 2.0, -TAM_ICONO - 4)
	add_child(icono)
	add_to_group("ocultar_en_misiones")
	_actualizar()
	Eventos.basura_recogida.connect(func(_c: int): _actualizar())
	Eventos.mesa_investigacion.connect(func(_d: bool): _actualizar())

func _actualizar() -> void:
	icono.visible = not Eventos.mesa_disponible
	if Eventos.mesa_disponible: # mision ya completada
		text = ""
	else:
		text = "%d/%d" % [Eventos.basura_recogida_total, Eventos.BASURA_MISION_1]
