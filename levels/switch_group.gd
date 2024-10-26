extends Node2D

signal switches_left_changed(switches_left)

var total_switches := 0
var active_switches := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_switches = get_child_count()
	for sw in get_children():
		sw.switch_pressed.connect(_on_switch_pressed)
		sw.switch_released.connect(_on_switch_released)
	## send initial switch count, ON NEXT FRAME, when sure UI elements are ready
	call_deferred("emit_switches_left")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func emit_switches_left() -> void:
	switches_left_changed.emit(total_switches - active_switches)


func _on_switch_pressed() -> void:
	active_switches += 1
	emit_switches_left()


func _on_switch_released() -> void:
	active_switches -= 1
	emit_switches_left()
