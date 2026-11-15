extends VBoxContainer
# Crea un boton y una pantalla (texto_mision) por cada linea de ARCHIVO.
# En el texto, "\n" escrito literalmente se vuelve salto de linea.

const ARCHIVO := "res://datos/misiones.txt"
const PANTALLA := preload("res://escenas/texto_mision.tscn")

func _ready() -> void:
	var raiz := get_node("../../..") # Misiones.tscn: Lista > Control > Panel_misiones > raiz
	var n := 0
	for linea in FileAccess.get_file_as_string(ARCHIVO).split("\n"):
		var texto: String = linea.strip_edges()
		if texto.is_empty():
			continue
		n += 1
		var pantalla := PANTALLA.instantiate()
		pantalla.name = "Mision%d" % n
		pantalla.visible = false
		pantalla.get_node("Label").text = texto.replace("\\n", "\n")
		raiz.add_child.call_deferred(pantalla) # raiz aun esta montando sus hijos
		var boton := Button.new()
		boton.text = "Mision %d" % n
		boton.custom_minimum_size = Vector2(300, 52)
		boton.add_theme_font_size_override("font_size", 24)
		boton.pressed.connect(pantalla.show)
		add_child(boton)
		pantalla.get_node("CerrarButton").pressed.connect(pantalla.hide)
		pantalla.get_node("FinalizadoButton").pressed.connect(_finalizar.bind(pantalla, n))
		if n <= 3: # misiones 1-3 se completan solas (vender basura, comprar mejoras)
			pantalla.get_node("FinalizadoButton").visible = false
	_actualizar()
	Eventos.mision_completada.connect(func(_numero: int): _actualizar())

func _finalizar(pantalla: Control, numero: int) -> void:
	pantalla.hide()
	Eventos.completar_mision(numero)

# Una mision se habilita cuando la anterior esta completada.
func _actualizar() -> void:
	for i in get_child_count():
		var boton: Button = get_child(i)
		boton.disabled = i > Eventos.misiones_completadas
		boton.text = "Mision %d" % (i + 1) + (" (lista)" if i < Eventos.misiones_completadas else "")
