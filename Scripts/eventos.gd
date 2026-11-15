extends Node

signal basura_recogida(cantidad: int)
signal mesa_investigacion(mesa_disponible: bool)
signal dinero_cambiado(dinero: int)
signal mision_completada(numero: int)

const PRECIO_BASURA := 5
const BASURA_MISION_1 := 5

# Estado que sobrevive a los cambios de escena (luna <-> nave).
var mesa_disponible := false
var dinero := 0
var basura_inventario := 0  # recogida y aun sin vender
var basura_vendida := 0
var misiones_completadas := 0

func _ready() -> void:
	mesa_investigacion.connect(func(disponible: bool): mesa_disponible = disponible)

func sumar_dinero(cantidad: int) -> void:
	dinero += cantidad
	dinero_cambiado.emit(dinero)

# Se llama al tocar la mesa de trabajo.
func vender_basura() -> void:
	if basura_inventario == 0:
		return
	print("Vendidas ", basura_inventario, " basuras: +", basura_inventario * PRECIO_BASURA)
	sumar_dinero(basura_inventario * PRECIO_BASURA)
	basura_vendida += basura_inventario
	basura_inventario = 0
	if basura_vendida >= BASURA_MISION_1:
		completar_mision(1)

func completar_mision(numero: int) -> void:
	if numero > misiones_completadas:
		misiones_completadas = numero
		mision_completada.emit(numero)
