class_name BounceState
extends State

var bounce_velocity: Vector2
var cooldown_timer: float = 0.0


func enter(msg: Dictionary = {}) -> void:
	bounce_velocity = msg.get("velocity", player.velocity) as Vector2
	player.velocity = bounce_velocity
	cooldown_timer = 0.0


func physics_update(delta: float) -> void:
	var phys: PlayerPhysics = player.physics

	cooldown_timer -= delta

	# Gravity
	player.velocity.y += phys.gravity * delta

	# Limited air control during bounce
	var input_dir: float = Input.get_axis(&"move_left", &"move_right")
	if input_dir != 0.0:
		player.velocity.x += input_dir * phys.acceleration * phys.air_control * 0.3 * delta

	# Move
	var velocity_before: Vector2 = player.velocity
	player.move_and_slide()

	# Reflect on collision (combine normals for corner safety)
	var collision_count: int = player.get_slide_collision_count()
	if collision_count > 0 and cooldown_timer <= 0.0:
		var combined_normal := Vector2.ZERO
		for i: int in collision_count:
			combined_normal += player.get_slide_collision(i).get_normal()
		combined_normal = combined_normal.normalized()

		var reflected: Vector2 = velocity_before.bounce(combined_normal)
		reflected *= phys.bounce_factor
		player.velocity = reflected
		cooldown_timer = phys.bounce_cooldown

	# Exit: speed drops below threshold
	if player.velocity.length() < phys.min_bounce_speed:
		state_machine.transition_to(&"GroundState")
		return

	# Claw can interrupt bounce
	if Input.is_action_just_pressed(&"claw"):
		if player.is_on_wall() or player.is_on_ceiling():
			state_machine.transition_to(&"ClawState")
			return
