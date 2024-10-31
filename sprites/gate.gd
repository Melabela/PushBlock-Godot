extends StaticBody2D

@export_enum("yellow", "blue") var gate_color: String = "yellow"

@onready var gate_sprite: Sprite2D = $GateSprite

const gateColorMap = {
	"yellow": preload("res://assets/switches/yellow_gate.png"),
	"blue": preload("res://assets/switches/blue_gate.png"),
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gate_sprite.texture = gateColorMap[gate_color]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
