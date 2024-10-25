extends StaticBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

const TILE_SIZE := 32.0
const MOVE_STEPS := 6

var bIsMoving := false
var nCurrStep := 0
var move_per_step := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func end_move() -> void:
	bIsMoving = false
	nCurrStep = 0
	move_per_step = Vector2.ZERO
	collision_shape_2d.set_collision_box(Vector2.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if bIsMoving:
		nCurrStep += 1
		var collision := move_and_collide(move_per_step)
		#print("PushBlock, isColl=", bColl != null)
		## 1. if collision, shouldn't move off tile,
		##     b/c wall tiles take entire tile space
		## 2. if done steps, should be at target tile
		if collision or (nCurrStep >= MOVE_STEPS):
			end_move()


## Returns if can accept the push_dir
## Reason it cannot:
##  - already moving in a direction
## Collision is handled by physics engine, not detected in this fn
func receive_push(push_dir: Vector2) -> bool:
	if bIsMoving:
		#print("Receive_push(), return early, as already moving")
		return false
	
	collision_shape_2d.set_collision_box(push_dir)
	var move_tile_size := push_dir * TILE_SIZE
	move_per_step = move_tile_size / MOVE_STEPS
	nCurrStep = 0
	bIsMoving = true
	return true
