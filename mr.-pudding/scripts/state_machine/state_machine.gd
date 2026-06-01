class_name StateMachine
extends Node

@export var initial_state: State
@export var player: CharacterBody2D

var current_state: State
var states: Dictionary = {}


func _ready() -> void:
	for child: Node in get_children():
		if child is State:
			states[child.name] = child
			child.player = player
			child.state_machine = self
			child.init()

	if initial_state:
		current_state = initial_state
		current_state.enter()


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)


func transition_to(target_state_name: StringName, msg: Dictionary = {}) -> void:
	if not states.has(target_state_name):
		push_warning("StateMachine: State '%s' not found." % target_state_name)
		return

	current_state.exit()
	current_state = states[target_state_name]
	current_state.enter(msg)
