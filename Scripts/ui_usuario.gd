extends Control

@onready var label: Label = $VBoxContainer/dinero_label

func _ready() -> void:
	_actualizar(Eventos.dinero)
	Eventos.dinero_cambiado.connect(_actualizar)

func _actualizar(dinero: int) -> void:
	label.text = "Dinero: %d" % dinero
