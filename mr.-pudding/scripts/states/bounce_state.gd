class_name BounceState
extends State

var bounce_velocity: Vector2


func enter(msg: Dictionary = {}) -> void:
	bounce_velocity = msg.get("velocity", player.velocity) as Vector2
	player.velocity = bounce_velocity


func physics_update(delta: float) -> void:
	var phys: PlayerPhysics = player.physics

	# Gravity
	player.velocity.y += phys.gravity * delta

	# Limited air control during bounce
	var input_dir: float = Input.get_axis(&"move_left", &"move_right")
	if input_dir != 0.0:
		player.velocity.x += input_dir * phys.acceleration * phys.air_control * 0.3 * delta

	# Move
	var velocity_before: Vector2 = player.velocity
	player.move_and_slide()

	# Reflect on collision
	for i: int in player.get_slide_collision_count():
		var collision: KinematicCollision2D = player.get_slide_collision(i)
		var normal: Vector2 = collision.get_normal()
		var reflected: Vector2 = velocity_before.bounce(normal)
		reflected *= phys.bounce_factor
		player.velocity = reflected

	# Exit: speed drops below threshold
	if player.velocity.length() < phys.min_bounce_speed:
		state_machine.transition_to(&"GroundState")
		return

	# Claw can interrupt bounce
	if Input.is_action_just_pressed(&"claw"):
		if player.is_on_wall() or player.is_on_ceiling():
			state_machine.transition_to(&"ClawState")
			return
