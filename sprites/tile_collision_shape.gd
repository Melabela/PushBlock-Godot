extends CollisionShape2D


const TILE_SIZE := 32.0
const TILE_SIZE_HALF := TILE_SIZE / 2

const CollisionBoxes = {
	Vector2.ZERO: {  ## i.e. not moving
		## cover entire tile
		"box_size": Vector2(TILE_SIZE, TILE_SIZE),
		"center_pos": Vector2(TILE_SIZE_HALF, TILE_SIZE_HALF),
	},
	Vector2.LEFT: {
		## flush to left edge, remove top/bottom edge pixels & 2 right pixels
		"box_size": Vector2(TILE_SIZE - 2.0, TILE_SIZE - 2.0),
		"center_pos": Vector2(TILE_SIZE_HALF - 1.0, TILE_SIZE_HALF),
	},
	Vector2.RIGHT: {
		## flush to right edge, remove top/bottom edge pixels & 2 left pixels
		"box_size": Vector2(TILE_SIZE -2.0, TILE_SIZE - 2.0),
		"center_pos": Vector2(TILE_SIZE_HALF + 1.0, TILE_SIZE_HALF),
	},
	Vector2.UP: {
		## flush to top edge, remove left/right edge pixels & 2 bottom pixels
		"box_size": Vector2(TILE_SIZE - 2.0, TILE_SIZE - 2.0),
		"center_pos": Vector2(TILE_SIZE_HALF, TILE_SIZE_HALF - 1.0),
	},
	Vector2.DOWN: {
		## flush to bottom edge, remove left/right edge pixels & 2 top pixels
		"box_size": Vector2(TILE_SIZE - 2.0, TILE_SIZE - 2.0),
		"center_pos": Vector2(TILE_SIZE_HALF, TILE_SIZE_HALF + 1.0),
	},
}


func set_collision_box(move_dir: Vector2) -> void:
	var box_info = CollisionBoxes[move_dir.normalized()]
	(shape as RectangleShape2D).size = box_info["box_size"]
	position = box_info["center_pos"]


func _ready() -> void:
	set_collision_box(Vector2.ZERO)
