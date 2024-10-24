extends CharacterBody2D


const TILE_SIZE := 32.0
const MOVE_MULTIPLIER := 8.0


const FLOAT_EPSILON = 0.0001

static func compare_floats(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon
	

func determine_collision_side(collision: KinematicCollision2D) -> Vector2:
	## get_angle() works for collisions
	##  - on player's bottom/top edges -> 0 / PI,
	##  - but NOT for those on left/right edges -> both(!) return 0.5 * PI,
	##     - for this latter case, need to compare positions as well
	var collAngle = collision.get_angle()
	#print("collision.angle: ", collAngle)
	if compare_floats(collAngle, 0.0):
		return Vector2.DOWN
	elif compare_floats(collAngle, PI):
		return Vector2.UP
	elif compare_floats(collAngle, PI / 2):
		## check whether left/right
		##  myPos (center) vs collisionPos
		var deltaX = collision.get_position().x - position.x
		if deltaX > FLOAT_EPSILON:
			return Vector2.RIGHT
		elif deltaX < -FLOAT_EPSILON:
			return Vector2.LEFT
	## default?
	return Vector2.ZERO


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	## get basic input & move
	var directionX := Input.get_axis("move_left", "move_right")
	velocity.x = TILE_SIZE * MOVE_MULTIPLIER * directionX
	var directionY := Input.get_axis("move_up", "move_down")
	velocity.y = TILE_SIZE * MOVE_MULTIPLIER * directionY
	var bCollision := move_and_slide()
	
	if bCollision:
		#print("Player - Got collision")
		var lastCollision := get_last_slide_collision()
		var collideObject := lastCollision.get_collider()
		#if "name" in collideObject:
		#	print(collideObject.name)
		if collideObject.is_in_group("PushBlock"):
			var collisionSide = determine_collision_side(lastCollision)
			#print("collisionSide: ", collisionSide)
			if collisionSide != Vector2.ZERO:
				collideObject.receive_push(collisionSide)

	## keep player within viewport
	var viewport_size := get_viewport_rect().size
	## player anchored in top-left corner
	position.x = clampf(position.x, 0, viewport_size.x - TILE_SIZE)
	position.y = clampf(position.y, 0, viewport_size.y - TILE_SIZE)
