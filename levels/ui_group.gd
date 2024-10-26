extends Control

## nodes elsewhere in scene
@onready var switch_group: Node2D = %SwitchGroup
@onready var player: CharacterBody2D = %Player
## child nodes
@onready var step_count_label: Label = $StepCountLabel
@onready var switch_count_label: Label = $SwitchCountLabel


func _ready() -> void:
	## connect player signal
	player.player_moved.connect(_on_player_moved)
	## connect switch_group signal
	switch_group.switches_left_changed.connect(_on_switches_left_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_moved(player_steps: int) -> void:
	step_count_label.text = "Steps Taken: " + str(player_steps)


func _on_switches_left_changed(sw_left_count: int) -> void:
	switch_count_label.text = "Switches Left: " + str(sw_left_count)
