extends Node2D

@onready var contador_basura: Label = $"../Ui/Contador_basura"
	
func _ready() -> void:
	contador_basura.text = "" if Eventos.mesa_disponible else "0/5"
	Eventos.basura_recogida.connect(_on_basura_recogida)

func _on_basura_recogida(cantidad: int) -> void:
	if Eventos.mesa_disponible: # mision ya completada
		return
	print("Llevas ", cantidad)
	
	if cantidad == 5:
		contador_basura.text = ""
		Eventos.mesa_investigacion.emit(true)
		print("¡Misión de basura completa!") # aquí va lo que quieras que pase
	else:
		contador_basura.text = "%d/5" % cantidad
		
