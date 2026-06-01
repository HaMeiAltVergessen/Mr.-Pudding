class_name PlayerPhysics
extends Resource

@export_group("Ground")
@export var move_speed: float = 300.0
@export var sprint_multiplier: float = 3
@export var jump_velocity: float = -400.0
@export var gravity: float = 480.0
@export var acceleration: float = 2000.0
@export var friction: float = 1500.0
@export var air_control: float = 0.8

@export_group("Bounce")
@export var bounce_threshold: float = 200.0
@export var bounce_factor: float = 0.9
@export var min_bounce_speed: float = 100.0
@export var bounce_cooldown: float = 0.15

@export_group("Claw")
@export var claw_deceleration: float = 800.0
@export var claw_max_grip_speed: float = 150.0
@export var claw_hang_duration: float = 3.0
@export var claw_slide_speed: float = 40.0
