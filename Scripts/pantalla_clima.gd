extends CanvasLayer

@onready var termometro: Sprite2D = $Esquina/Termometro

func _ready() -> void:
	termometro.frame = Eventos.clima
	Eventos.clima_cambiado.connect(func(clima: int): termometro.frame = clima)
