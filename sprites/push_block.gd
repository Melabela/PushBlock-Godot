extends StaticBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

const TILE_SIZE := 32.0
const TILE_SIZE_HALF := TILE_SIZE / 2
const TILE_SIZE_QRTR := TILE_SIZE / 4
const MOVE_STEPS := 8

const CollisionBoxes = {
	Vector2.ZERO: {  ## i.e. not moving
		## cover entire tile
		"box_size": Vector2(TILE_SIZE, TILE_SIZE),
		"center_pos": Vector2(TILE_SIZE_HALF, TILE_SIZE_HALF),
	},
	Vector2.LEFT: {
		## cover left-half, except top & bottom pixels
		"box_size": Vector2(TILE_SIZE_HALF, TILE_SIZE - 2.0),
		"center_pos": Vector2(TILE_SIZE_QRTR, TILE_SIZE_HALF),
	},
	Vector2.RIGHT: {
		## cover right-half, except top & bottom pixels
		"box_size": Vector2(TILE_SIZE_HALF, TILE_SIZE - 2.0),
		"center_pos": Vector2(3 * TILE_SIZE_QRTR, TILE_SIZE_HALF),
	},
	Vector2.UP: {
		## cover top-half, except left & right pixels
		"box_size": Vector2(TILE_SIZE - 2.0, TILE_SIZE_HALF),
		"center_pos": Vector2(TILE_SIZE_HALF, TILE_SIZE_QRTR),
	},
	Vector2.DOWN: {
		## cover bottom-half, except left & right pixels
		"box_size": Vector2(TILE_SIZE - 2.0, TILE_SIZE_HALF),
		"center_pos": Vector2(TILE_SIZE_HALF, 3 * TILE_SIZE_QRTR),
	},
}

var bIsMoving := false
var nCurrStep := 0
var move_per_step := Vector2.ZERO
var target_position := Vector2.ZERO


func set_collision_box(move_dir: Vector2) -> void:
	var box_info = CollisionBoxes[move_dir.normalized()]
	(collision_shape_2d.shape as RectangleShape2D).size = box_info["box_size"]
	collision_shape_2d.position = box_info["center_pos"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func clear_move_vars() -> void:
	bIsMoving = false
	nCurrStep = 0
	move_per_step = Vector2.ZERO
	target_position = Vector2.ZERO
	set_collision_box(Vector2.ZERO)


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
	
	set_collision_box(push_dir)
	move_per_step = move / MOVE_STEPS
	nCurrStep = 0
	bIsMoving = true
	return true
