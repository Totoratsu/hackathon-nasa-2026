extends Node

signal basura_recogida(cantidad: int)
signal mesa_investigacion(mesa_disponible: bool)
signal dinero_cambiado(dinero: int)
signal mision_completada(numero: int)
signal clima_cambiado(clima: int)
signal mejora_cambiada(mejora: int)

const PRECIO_BASURA := 5
const BASURA_MISION_1 := 5

# Mismo orden que los dibujos de sprites clima.png: 0 = frio, 1 = normal, 2 = caliente
enum Clima { FRIO, NORMAL, CALIENTE }
const SEGUNDOS_CLIMA := 10.0
const SIN_MEJORA := -1
const PRECIO_MEJORA := 15       # 3 basuras vendidas
const DURACION_MEJORA := 60.0   # segundos

# Estado que sobrevive a los cambios de escena (luna <-> nave).
var mesa_disponible := false
var dinero := 0
var basura_inventario := 0  # recogida y aun sin vender
var basura_vendida := 0
var basura_recogida_total := 0  # total recogido (para el contador de la mision 1)
var misiones_completadas := 0
var clima: Clima = Clima.NORMAL
# La mejora es el clima que aguanta el traje (FRIO o CALIENTE). Solo una a la vez.
var mejora: int = SIN_MEJORA
var timer_mejora := Timer.new()

func _ready() -> void:
	mesa_investigacion.connect(func(disponible: bool): mesa_disponible = disponible)
	# Los timers viven en el autoload, asi siguen corriendo al cambiar de escena.
	var timer_clima := Timer.new()
	timer_clima.wait_time = SEGUNDOS_CLIMA
	timer_clima.timeout.connect(_cambiar_clima)
	add_child(timer_clima)
	timer_clima.start()
	timer_mejora.one_shot = true
	timer_mejora.timeout.connect(_quitar_mejora)
	add_child(timer_mejora)

func sumar_dinero(cantidad: int) -> void:
	dinero += cantidad
	dinero_cambiado.emit(dinero)


# Boton "Vender basura" del menu de investigacion: una basura por pulsacion.
func vender_una_basura() -> void:
	if basura_inventario == 0:
		return
	basura_inventario -= 1
	sumar_dinero(PRECIO_BASURA)
	basura_vendida += 1
	if basura_vendida >= BASURA_MISION_1:
		completar_mision(1)

func completar_mision(numero: int) -> void:
	if numero > misiones_completadas:
		misiones_completadas = numero
		mision_completada.emit(numero)

func _cambiar_clima() -> void:
	clima = randi_range(0, 2) as Clima
	clima_cambiado.emit(clima)
	print("Clima: ", Clima.keys()[clima])

func comprar_mejora(tipo: Clima) -> void:
	if dinero < PRECIO_MEJORA:
		print("No te alcanza: necesitas ", PRECIO_MEJORA)
		return
	sumar_dinero(-PRECIO_MEJORA)
	mejora = tipo                        # reemplaza la anterior
	timer_mejora.start(DURACION_MEJORA)  # el tiempo empieza de cero
	mejora_cambiada.emit(mejora)
	print("Mejora comprada: ", Clima.keys()[tipo], " (", int(DURACION_MEJORA), " s). Dinero restante: ", dinero)

func _quitar_mejora() -> void:
	print("La mejora expiró")
	mejora = SIN_MEJORA
	mejora_cambiada.emit(mejora)

func puede_salir() -> bool:
	return clima == Clima.NORMAL or clima == mejora
