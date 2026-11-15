extends CanvasLayer

@onready var termometro: Sprite2D = $Esquina/Termometro

func _ready() -> void:
	add_to_group("ocultar_en_misiones")
	termometro.frame = Eventos.clima
	Eventos.clima_cambiado.connect(func(clima: int): termometro.frame = clima)
