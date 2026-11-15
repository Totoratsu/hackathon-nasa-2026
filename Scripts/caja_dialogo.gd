extends CanvasLayer
# Caja de dialogo estilo "RPG clasico": aparece abajo, escribe el texto letra por letra
# y muestra una flecha parpadeante justo al final del texto. Se cierra con E / Enter /
# Espacio o sola tras unos segundos.
# Se usa desde cualquier escena con: Eventos.decir("texto")

const VELOCIDAD := 45.0          # letras por segundo
const FLECHA := " ▼"             # se pega al final del texto
const COLOR_FONDO := Color(0.93, 0.92, 0.86)
const COLOR_BORDE := Color(0.1, 0.1, 0.16)
const COLOR_TEXTO := Color(0.1, 0.1, 0.16)

# Hoja de sprites del perro: 9 columnas x 2 filas de 128x128.
# Fila de abajo, columnas 3-5: el perro de frente.
const HOJA_PERRO := preload("res://Sprites/SPRITES perro-07.png")
const CELDA_PERRO := 128
const FRAMES_HABLANDO := [3, 4, 5]   # columnas (fila 1) que se alternan al hablar
const SEG_POR_FRAME := 0.14
const TAM_PERRO := 96                # tamano en pantalla

var _panel: PanelContainer
var _perro: TextureRect
var _frame_actual := 0
var _tiempo_frame := 0.0
var _label: Label
var _texto := ""                 # mensaje sin la flecha
var _tween: Tween
var _escribiendo := false
var _espera := 0.0               # segundos que faltan para cerrar sola

func _ready() -> void:
	layer = 100 # por encima de menus y del HUD
	_panel = PanelContainer.new()
	_panel.anchor_left = 0.12
	_panel.anchor_right = 0.88
	_panel.anchor_top = 0.72
	_panel.anchor_bottom = 0.95
	_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Marco doble: borde oscuro exterior + hueco claro + borde oscuro interior.
	var exterior := StyleBoxFlat.new()
	exterior.bg_color = COLOR_FONDO
	exterior.set_border_width_all(5)
	exterior.border_color = COLOR_BORDE
	exterior.set_content_margin_all(7)
	_panel.add_theme_stylebox_override("panel", exterior)

	var interior := PanelContainer.new()
	var estilo_interior := StyleBoxFlat.new()
	estilo_interior.bg_color = COLOR_FONDO
	estilo_interior.set_border_width_all(3)
	estilo_interior.border_color = COLOR_BORDE
	estilo_interior.content_margin_left = 16
	estilo_interior.content_margin_right = 24
	estilo_interior.content_margin_top = 10
	estilo_interior.content_margin_bottom = 10
	interior.add_theme_stylebox_override("panel", estilo_interior)
	interior.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_panel.add_child(interior)

	# Perro a la izquierda, texto a la derecha: como si el perro hablara.
	var fila := HBoxContainer.new()
	fila.add_theme_constant_override("separation", 28) # separacion perro-texto
	fila.mouse_filter = Control.MOUSE_FILTER_IGNORE
	interior.add_child(fila)

	_perro = TextureRect.new()
	_perro.custom_minimum_size = Vector2(TAM_PERRO, TAM_PERRO)
	_perro.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_perro.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_perro.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_perro.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_perro.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_perro.texture = _frame_perro(FRAMES_HABLANDO[0])
	fila.add_child(_perro)

	_label = Label.new()
	_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_label.add_theme_font_size_override("font_size", 28)
	_label.add_theme_color_override("font_color", COLOR_TEXTO)
	_label.add_theme_constant_override("line_spacing", 10)
	_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fila.add_child(_label)

	add_child(_panel)
	_panel.hide()

func _frame_perro(columna: int) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = HOJA_PERRO
	atlas.region = Rect2(columna * CELDA_PERRO, CELDA_PERRO, CELDA_PERRO, CELDA_PERRO)
	return atlas

func mostrar(texto: String, segundos_visible := 4.0) -> void:
	if _panel.visible and _texto == texto:
		return # ya se esta mostrando este mismo mensaje
	_texto = texto
	# La flecha va dentro del texto, asi queda siempre al final de la ultima linea.
	_label.text = texto + FLECHA
	_label.visible_characters = 0
	_panel.show()
	_escribiendo = true
	_espera = segundos_visible
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(_label, "visible_characters", texto.length(), texto.length() / VELOCIDAD)
	_tween.finished.connect(_terminar_de_escribir)

func _terminar_de_escribir() -> void:
	_escribiendo = false
	_label.visible_characters = _texto.length() # sin flecha hasta que parpadee

func cerrar() -> void:
	if _tween:
		_tween.kill()
	_escribiendo = false
	_panel.hide()

func _process(delta: float) -> void:
	if not _panel.visible:
		return
	# El perro "habla" (alterna frames) mientras se escribe el texto; luego se queda quieto.
	if _escribiendo:
		_tiempo_frame += delta
		if _tiempo_frame >= SEG_POR_FRAME:
			_tiempo_frame = 0.0
			_frame_actual = (_frame_actual + 1) % FRAMES_HABLANDO.size()
			_perro.texture = _frame_perro(FRAMES_HABLANDO[_frame_actual])
	elif _frame_actual != 0:
		_frame_actual = 0
		_perro.texture = _frame_perro(FRAMES_HABLANDO[0])
	if Input.is_action_just_pressed("interactuar") or Input.is_action_just_pressed("ui_accept"):
		if _escribiendo:
			if _tween:
				_tween.kill()
			_terminar_de_escribir() # primera pulsacion: muestra todo el texto
		else:
			cerrar()                # segunda: cierra
		return
	if not _escribiendo:
		# Parpadeo: con flecha (todos los caracteres) o sin ella (solo el mensaje).
		var con_flecha := fmod(Time.get_ticks_msec() / 1000.0, 0.8) < 0.5
		_label.visible_characters = -1 if con_flecha else _texto.length() + 1
		_espera -= delta
		if _espera <= 0.0:
			cerrar()
