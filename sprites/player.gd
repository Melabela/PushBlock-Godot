extends CharacterBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

signal player_moved(step_count)

const TILE_SIZE := 32.0
const MOVE_STEPS := 6

var bIsMoving := false
var nCurrStep := 0
var move_per_step := Vector2.ZERO

## show in UI
var player_steps := 0


func _ready() -> void:
	pass


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


func get_input_dir() -> Vector2:
	var dir := Vector2.ZERO
	if Input.is_action_just_pressed("move_left"):
		dir.x = -1
	elif Input.is_action_just_pressed("move_right"):
		dir.x = +1
	elif Input.is_action_just_pressed("move_up"):
		dir.y = -1
	elif Input.is_action_just_pressed("move_down"):
		dir.y = +1
	return dir


func clamp_position_in_viewport() -> void:
	## keep player within viewport
	var viewport_size := get_viewport_rect().size
	## player anchored in top-left corner
	position.x = clampf(position.x, 0, viewport_size.x - TILE_SIZE)
	position.y = clampf(position.y, 0, viewport_size.y - TILE_SIZE)


func end_move() -> void:
	bIsMoving = false
	nCurrStep = 0
	move_per_step = Vector2.ZERO
	collision_shape_2d.set_collision_box(velocity)


func increment_step_count() -> void:
	player_steps += 1
	player_moved.emit(player_steps)


func _physics_process(delta: float) -> void:
	if bIsMoving:
		nCurrStep += 1
		var collision := move_and_collide(move_per_step)
		clamp_position_in_viewport()
		if nCurrStep >= MOVE_STEPS:
			## if moved, and didn't collide first, (nCurrStep > 0)
			## but update & report at end of move steps
			increment_step_count()
		if collision or (nCurrStep >= MOVE_STEPS):
			end_move()
		if collision:
			#print("Player - Got collision")
			var collideObject := collision.get_collider()
			#if "name" in collideObject:
			#	print(collideObject.name)
			if collideObject.is_in_group("PushBlock"):
				var collisionSide = determine_collision_side(collision)
				#print("collisionSide: ", collisionSide)
				if collisionSide != Vector2.ZERO:
					collideObject.receive_push(collisionSide)
	else:
		var move_dir := get_input_dir()
		if move_dir != Vector2.ZERO:
			collision_shape_2d.set_collision_box(move_dir)
			## velocity calc: see variables at top of file
			var move_tile_size := move_dir * TILE_SIZE
			move_per_step = move_tile_size / MOVE_STEPS
			nCurrStep = 0
			bIsMoving = true
