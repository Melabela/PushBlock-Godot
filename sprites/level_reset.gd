extends Area2D

signal level_reset_triggered

const FRAME_DELAY := 6
var frame_countdown := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if frame_countdown > 0:
		frame_countdown -= 1
		if frame_countdown == 0:
			level_reset_triggered.emit()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#print("LevelReset: _on_body_entered(), Player")
		frame_countdown = FRAME_DELAY
