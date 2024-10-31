extends Area2D

@export_enum("yellow", "blue") var switch_color: String = "yellow"

@onready var switch_sprite: Sprite2D = $SwitchSprite

signal switch_pressed(color)
signal switch_released(color)

const switchColorMap = {
	"yellow": preload("res://assets/switches/yellow_switch.png"),
	"blue": preload("res://assets/switches/blue_switch.png"),
}

var bIsPressed := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	switch_sprite.texture = switchColorMap[switch_color]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	#print("Switch: _on_body_entered()")
	bIsPressed = true
	switch_pressed.emit(switch_color)


func _on_body_exited(body: Node2D) -> void:
	#print("Switch: _on_body_exited()")
	bIsPressed = false
	switch_released.emit(switch_color)
