extends StaticBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

const TILE_SIZE := 32.0
const MOVE_STEPS := 8

var bIsMoving := false
var nCurrStep := 0
var move_per_step := Vector2.ZERO
var target_position := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func clear_move_vars() -> void:
	bIsMoving = false
	nCurrStep = 0
	move_per_step = Vector2.ZERO
	target_position = Vector2.ZERO
	collision_shape_2d.set_collision_box(Vector2.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if bIsMoving:
		nCurrStep += 1
		var bColl := move_and_collide(move_per_step)
		#print("PushBlock, isColl=", bColl != null)
		## 1. if collision, shouldn't move off tile,
		##     b/c wall tiles take entire tile space
		## 2. if done steps, should be at target tile
		if bColl or (nCurrStep >= MOVE_STEPS):
			clear_move_vars()


## Returns if can accept the push_dir
## Reason it cannot:
##  - already moving in a direction
## Collision is handled by physics engine, not detected in this fn
func receive_push(push_dir: Vector2) -> bool:
	if bIsMoving:
		#print("Receive_push(), return early, as already moving")
		return false
	
	var move := (push_dir * TILE_SIZE)
	target_position = position + move
	#print("Receive_push(), push_dir=", push_dir)
	#print("    - position=", position, ", target_pos=", target_position)
	
	collision_shape_2d.set_collision_box(push_dir)
	move_per_step = move / MOVE_STEPS
	nCurrStep = 0
	bIsMoving = true
	return true
