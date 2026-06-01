class_name ClawState
extends State

var surface_normal: Vector2
var grip_velocity: float


func enter(_msg: Dictionary = {}) -> void:
	surface_normal = _get_contact_normal()
	var tangent: Vector2 = Vector2(-surface_normal.y, surface_normal.x)
	grip_velocity = player.velocity.dot(tangent)
	player.velocity = Vector2.ZERO


func physics_update(delta: float) -> void:
	var phys: PlayerPhysics = player.physics

	# Decelerate toward zero
	grip_velocity = move_toward(grip_velocity, 0.0, phys.claw_deceleration * delta)

	# Allow small movement along surface if gripped
	if absf(grip_velocity) < phys.claw_max_grip_speed:
		var input_dir: float = Input.get_axis(&"move_left", &"move_right")
		grip_velocity = input_dir * phys.claw_max_grip_speed * 0.5

	# Apply velocity along surface tangent
	surface_normal = _get_contact_normal()
	var tangent: Vector2 = Vector2(-surface_normal.y, surface_normal.x)
	player.velocity = tangent * grip_velocity

	# Push into surface to maintain contact
	player.velocity -= surface_normal * 10.0

	player.move_and_slide()

	# Exit: released claw
	if Input.is_action_just_released(&"claw"):
		state_machine.transition_to(&"GroundState")
		return

	# Exit: lost contact
	if not player.is_on_wall() and not player.is_on_ceiling():
		state_machine.transition_to(&"GroundState")
		return

	# Wall jump
	if Input.is_action_just_pressed(&"jump"):
		player.velocity = surface_normal * player.physics.move_speed * 0.8
		player.velocity.y = player.physics.jump_velocity * 0.8
		state_machine.transition_to(&"GroundState")
		return


func _get_contact_normal() -> Vector2:
	if player.is_on_wall():
		return player.get_wall_normal()
	elif player.is_on_ceiling():
		return Vector2.DOWN
	return Vector2.UP
