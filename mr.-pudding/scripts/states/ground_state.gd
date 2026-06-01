class_name GroundState
extends State


func enter(_msg: Dictionary = {}) -> void:
	print("[GroundState] Entered. Player = ", player, " | Physics = ", player.physics if player else "NO PLAYER")


func physics_update(delta: float) -> void:
	if not player:
		print("[GroundState] ERROR: player is null!")
		return
	if not player.physics:
		print("[GroundState] ERROR: player.physics is null!")
		return

	var phys: PlayerPhysics = player.physics

	# Gravity
	if not player.is_on_floor():
		player.velocity.y += phys.gravity * delta

	# Horizontal movement
	var input_dir: float = Input.get_axis(&"move_left", &"move_right")
	var target_speed: float = phys.move_speed
	if Input.is_action_pressed(&"sprint"):
		target_speed *= phys.sprint_multiplier

	var control: float = 1.0 if player.is_on_floor() else phys.air_control

	if input_dir != 0.0:
		player.velocity.x = move_toward(
			player.velocity.x,
			input_dir * target_speed,
			phys.acceleration * control * delta
		)
	else:
		player.velocity.x = move_toward(
			player.velocity.x, 0.0,
			phys.friction * control * delta
		)

	# Jump
	if Input.is_action_just_pressed(&"jump") and player.is_on_floor():
		player.velocity.y = phys.jump_velocity

	# Move and check transitions
	var velocity_before: Vector2 = player.velocity
	player.move_and_slide()

	# Transition to BounceState on strong impact
	if player.get_slide_collision_count() > 0:
		var impact_speed: float = (velocity_before - player.velocity).length()
		if impact_speed > phys.bounce_threshold:
			state_machine.transition_to(
				&"BounceState",
				{"velocity": velocity_before}
			)
			return

	# Transition to ClawState
	if Input.is_action_just_pressed(&"claw"):
		if player.is_on_wall() or player.is_on_ceiling():
			state_machine.transition_to(&"ClawState")
			return
