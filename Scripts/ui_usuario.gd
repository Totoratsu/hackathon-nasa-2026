extends Control

@onready var label: Label = $Fila/dinero_label

func _ready() -> void:
	_actualizar(Eventos.dinero)
	Eventos.dinero_cambiado.connect(_actualizar)

func _actualizar(dinero: int) -> void:
	label.text = str(dinero)
