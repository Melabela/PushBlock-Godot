extends CharacterBody2D


const TILE_SIZE := 32.0
const TILE_SIZE_HALF := TILE_SIZE / 2.0
const SPEED := 200.0


const FLOAT_EPSILON = 0.0001

static func compare_floats(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon
	

func _determine_collision_side(collision: KinematicCollision2D) -> Vector2:
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


func _physics_process(delta: float) -> void:
	## get basic input & move
	var directionX := Input.get_axis("move_left", "move_right")
	velocity.x = SPEED * directionX
	var directionY := Input.get_axis("move_up", "move_down")
	velocity.y = SPEED * directionY
	var bCollision := move_and_slide()
	
	if bCollision:
		#print("Player - Got collision")
		var lastCollision := get_last_slide_collision()
		var collideObject := lastCollision.get_collider()
		#if "name" in collideObject:
		#	print(collideObject.name)
		if collideObject.is_in_group("PushBlock"):
			var rigBody2D := collideObject as RigidBody2D
			var collisionSide = _determine_collision_side(lastCollision)
			print("collisionSide: ", collisionSide)
			if collisionSide != Vector2.ZERO:
				rigBody2D.receive_push(collisionSide)

	## keep player within viewport
	var viewport_size := get_viewport_rect().size
	## player anchored in center of sprite, so need bound by 1/2 TILE
	position.x = clampf(position.x, TILE_SIZE_HALF, viewport_size.x - TILE_SIZE_HALF)
	position.y = clampf(position.y, TILE_SIZE_HALF, viewport_size.y - TILE_SIZE_HALF)
