extends Control

## nodes elsewhere in scene
@onready var switch_group: Node2D = %SwitchGroup
@onready var player: CharacterBody2D = %Player
## child nodes
@onready var step_count_label: Label = $StepCountLabel
@onready var switch_count_label: Label = $SwitchCountLabel

## TESTING ONLY, REMOVE ME LATER
var nFrame := 0
var nSwitch := 0


func _ready() -> void:
	## connect player signal
	player.player_moved.connect(_on_player_moved)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	nFrame += 1
	if (nFrame % 10) == 0:
		nSwitch += 1
		update_switch_count_label(nSwitch)


func _on_player_moved(player_steps: int) -> void:
	step_count_label.text = "Steps Taken: " + str(player_steps)


func update_switch_count_label(new_count_left: int) -> void:
	switch_count_label.text = "Switches Left: " + str(new_count_left)
