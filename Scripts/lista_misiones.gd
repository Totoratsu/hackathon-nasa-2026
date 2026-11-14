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
		boton.custom_minimum_size = Vector2(200, 0)
		boton.disabled = n > 1
		boton.pressed.connect(pantalla.show)
		add_child(boton)
		pantalla.get_node("CerrarButton").pressed.connect(pantalla.hide)
		pantalla.get_node("FinalizadoButton").pressed.connect(_finalizar.bind(pantalla, n - 1))

func _finalizar(pantalla: Control, indice: int) -> void:
	pantalla.hide()
	if indice + 1 < get_child_count():
		get_child(indice + 1).disabled = false
