extends StaticBody2D

var jugador_cerca := false

@onready var zona: Area2D = $ZonaInteraccion
@onready var panel: ColorRect = $Canvas/Panel

func _ready() -> void:
	zona.body_entered.connect(_on_body_entered)
	zona.body_exited.connect(_on_body_exited)
	panel.visible = false
	$Canvas/Panel/CerrarButton.pressed.connect(panel.hide)
	$Canvas/Panel/Botones/FrioButton.pressed.connect(_on_frio_pressed)
	$Canvas/Panel/Botones/CalorButton.pressed.connect(_on_calor_pressed)
	$Canvas/Panel/Botones/OxigenoButton.pressed.connect(_on_oxigeno_pressed)
	$Canvas/Panel/Botones/VenderButton.pressed.connect(Eventos.vender_una_basura)

func _on_frio_pressed() -> void:
	Eventos.comprar_mejora(Eventos.Clima.FRIO)

func _on_oxigeno_pressed() -> void:
	Eventos.comprar_oxigeno()

func _on_calor_pressed() -> void:
	Eventos.comprar_mejora(Eventos.Clima.CALIENTE)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = false

func _actualizar_panel() -> void:
	var puede_mejorar: bool = Eventos.dinero >= Eventos.PRECIO_MEJORA
	$Canvas/Panel/Botones/FrioButton.disabled = not puede_mejorar
	$Canvas/Panel/Botones/CalorButton.disabled = not puede_mejorar
	$Canvas/Panel/Botones/OxigenoButton.disabled = Eventos.oxigeno_mejorado or Eventos.dinero < Eventos.PRECIO_OXIGENO
	$Canvas/Panel/Botones/VenderButton.disabled = Eventos.basura_inventario <= 0
	$Canvas/Panel/InfoLabel.text = "Dinero: %d   Basura: %d" % [Eventos.dinero, Eventos.basura_inventario]

func _process(_delta: float) -> void:
	if panel.visible:
		_actualizar_panel()
	if jugador_cerca and Input.is_action_just_pressed("basura"):
		if Eventos.mesa_disponible:
			panel.show()
		else:
			print("La mesa de investigacion aun no esta disponible")
