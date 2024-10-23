extends RigidBody2D

const TILE_SIZE := 32.0
const TILE_SIZE_HALF := TILE_SIZE / 2.0
const FORCE_MULTIPLIER := 60.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func receive_push(push_dir: Vector2) -> void:
	print("Receive_push(), push_dir=", push_dir)
	apply_central_force(push_dir * FORCE_MULTIPLIER)
	
