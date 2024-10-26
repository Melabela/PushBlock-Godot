extends Control

## nodes elsewhere in scene
@onready var switch_group: Node2D = %SwitchGroup
@onready var player: CharacterBody2D = %Player
## child nodes
@onready var step_count_label: Label = $StepCountLabel
@onready var switch_count_label: Label = $SwitchCountLabel

## TESTING ONLY, REMOVE ME LATER
var nFrame := 0
var nStep := 0
var nSwitch := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	nFrame += 1
	if (nFrame % 10) == 0:
		nStep += 1
		nSwitch += 1
		update_step_count_label(nStep)
		update_switch_count_label(nSwitch)


func update_step_count_label(new_count: int) -> void:
	step_count_label.text = "Steps Taken: " + str(new_count)


func update_switch_count_label(new_count_left: int) -> void:
	switch_count_label.text = "Switches Left: " + str(new_count_left)
