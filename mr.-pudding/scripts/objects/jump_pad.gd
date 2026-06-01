class_name JumpPad
extends Area2D

@export var launch_strength: float = 600.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player := body as Player
		player.velocity = Vector2(player.velocity.x, -launch_strength)
		var sm: StateMachine = player.get_node("StateMachine")
		sm.transition_to(&"BounceState", {"velocity": player.velocity})
