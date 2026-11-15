extends CanvasLayer

# Hoja con los iconos de las mejoras (copo de nieve y llama), junto a los botones de la mesa.
const HOJA_ICONOS := preload("res://Sprites/sprites mesa de trabajo.png")
const REGION_FRIO := Rect2(906, 139, 106, 104)     # copo de nieve
const REGION_CALOR := Rect2(905, 11, 110, 104)     # llama

@onready var termometro: Sprite2D = $Esquina/Termometro
@onready var icono_mejora: Sprite2D = $Esquina/IconoMejora

func _ready() -> void:
	add_to_group("ocultar_en_misiones")
	termometro.frame = Eventos.clima
	Eventos.clima_cambiado.connect(func(clima: int): termometro.frame = clima)
	# El icono aparece al comprar una mejora y desaparece cuando expira.
	_mostrar_mejora(Eventos.mejora)
	Eventos.mejora_cambiada.connect(_mostrar_mejora)

func _mostrar_mejora(mejora: int) -> void:
	if mejora == Eventos.SIN_MEJORA:
		icono_mejora.visible = false
		return
	var atlas := AtlasTexture.new()
	atlas.atlas = HOJA_ICONOS
	atlas.region = REGION_FRIO if mejora == Eventos.Clima.FRIO else REGION_CALOR
	icono_mejora.texture = atlas
	icono_mejora.visible = true
