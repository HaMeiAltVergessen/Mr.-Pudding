class_name PlayerPhysics
extends Resource

@export_group("Ground")
@export var move_speed: float = 300.0
@export var sprint_multiplier: float = 1.6
@export var jump_velocity: float = -500.0
@export var gravity: float = 980.0
@export var acceleration: float = 2000.0
@export var friction: float = 1500.0
@export var air_control: float = 0.6

@export_group("Bounce")
@export var bounce_threshold: float = 400.0
@export var bounce_factor: float = 0.75
@export var min_bounce_speed: float = 100.0

@export_group("Claw")
@export var claw_deceleration: float = 800.0
@export var claw_max_grip_speed: float = 150.0
