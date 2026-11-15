extends Control

@onready var configuracion_button: Button = $VBoxContainer/Configuracion_button
@onready var panel_misiones: ColorRect = $Panel_misiones
@onready var cerrar_button: Button = $Panel_misiones/CerrarButton

# Nodos del HUD (termometro, contador de basura...) que se ocultan mientras
# el menu de misiones esta abierto: se apuntan al grupo con add_to_group.
const GRUPO_HUD := "ocultar_en_misiones"

func _ready() -> void:
	configuracion_button.button_down.connect(_on_misiones_pressed)
	cerrar_button.pressed.connect(_on_cerrar_pressed)
	panel_misiones.visible = false

func _on_misiones_pressed() -> void:
	panel_misiones.visible = true
	get_tree().call_group(GRUPO_HUD, "set_visible", false)

func _on_cerrar_pressed() -> void:
	panel_misiones.visible = false
	get_tree().call_group(GRUPO_HUD, "set_visible", true)
