extends CollisionShape2D


const TILE_SIZE := 32.0
const TILE_SIZE_HALF := TILE_SIZE / 2
const TILE_SIZE_QRTR := TILE_SIZE / 4

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


func set_collision_box(move_dir: Vector2) -> void:
	var box_info = CollisionBoxes[move_dir.normalized()]
	(shape as RectangleShape2D).size = box_info["box_size"]
	position = box_info["center_pos"]


func _ready() -> void:
	set_collision_box(Vector2.ZERO)
