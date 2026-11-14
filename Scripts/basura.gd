extends StaticBody2D

var jugador_cerca : bool = false

@onready var zona: Area2D = $ZonaInteraccion

func _ready():
	zona.body_entered.connect(_on_body_entered)
	zona.body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		jugador_cerca = true

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		jugador_cerca = false

func _process(_delta):
	if jugador_cerca and Input.is_action_pressed("basura"):
		queue_free()
