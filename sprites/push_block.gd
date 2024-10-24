extends StaticBody2D

const TILE_SIZE := 32.0

var current_move_dir := Vector2.ZERO
var target_position := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## find position to closest TILE
## (since block anchored to top-left, can just round in TILE-units)
func get_nearest_tile_pos() -> Vector2:
	var tile_pos := position / TILE_SIZE
	return tile_pos.round() * TILE_SIZE


## Returns if can accept the push_dir
## Reasons it cannot are:
##  - already moving in a direction
##  - against a wall, and can't move in that dir
func receive_push(push_dir: Vector2) -> bool:
	if current_move_dir != Vector2.ZERO:
		#print("Receive_push(), return early, as already moving")
		return false
	
	#current_move_dir = push_dir
	target_position = position + (push_dir * TILE_SIZE)
	#print("Receive_push(), push_dir=", push_dir)
	#print("    - position=", position, ", target_pos=", target_position)
	
	var coll := move_and_collide((push_dir * TILE_SIZE))
	print("PushBlock, isColl=", coll != null)
	return true
