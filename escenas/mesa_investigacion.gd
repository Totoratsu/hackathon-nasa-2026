extends StaticBody2D

var jugador_cerca := false

@onready var zona: Area2D = $ZonaInteraccion
@onready var panel: ColorRect = $Canvas/Panel

func _ready() -> void:
	zona.body_entered.connect(_on_body_entered)
	zona.body_exited.connect(_on_body_exited)
	panel.visible = false
	$Canvas/Panel/CerrarButton.pressed.connect(panel.hide)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = true
		Eventos.vender_basura()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = false

func _process(_delta: float) -> void:
	if jugador_cerca and Input.is_action_just_pressed("basura"):
		if Eventos.mesa_disponible:
			panel.show()
		else:
			print("La mesa de investigacion aun no esta disponible")
