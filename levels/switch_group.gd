extends Node2D

signal switches_left_changed(switches_left)

var total_switches := 0
var active_switches := 0
var switch_total_by_color := {}
var switch_active_by_color := {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_switches = get_child_count()
	for sw in get_children():
		sw.switch_pressed.connect(_on_switch_pressed)
		sw.switch_released.connect(_on_switch_released)
		## count switches by color
		if sw.switch_color not in switch_total_by_color:
			switch_total_by_color[sw.switch_color] = 0
			switch_active_by_color[sw.switch_color] = 0
		switch_total_by_color[sw.switch_color] += 1
	## send initial switch count, ON NEXT FRAME, when sure UI elements are ready
	call_deferred("emit_switches_left")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func emit_switches_left() -> void:
	switches_left_changed.emit(total_switches - active_switches)


func _on_switch_pressed(color: String) -> void:
	active_switches += 1
	switch_active_by_color[color] += 1
	emit_switches_left()


func _on_switch_released(color: String) -> void:
	active_switches -= 1
	switch_active_by_color[color] -= 1
	emit_switches_left()
