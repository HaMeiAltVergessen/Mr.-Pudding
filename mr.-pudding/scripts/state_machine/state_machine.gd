class_name StateMachine
extends Node

@export var initial_state: State
@export var player: CharacterBody2D

var current_state: State
var states: Dictionary = {}


func _ready() -> void:
	# Debug: check if exports resolved
	print("[StateMachine] _ready called")
	print("[StateMachine] player export = ", player)
	print("[StateMachine] initial_state export = ", initial_state)

	# Fallback: if player export didn't resolve, find parent CharacterBody2D
	if not player:
		var parent := get_parent()
		if parent is CharacterBody2D:
			player = parent
			print("[StateMachine] player resolved via parent: ", player)

	# Fallback: if initial_state didn't resolve, use first State child
	if not initial_state:
		for child: Node in get_children():
			if child is State:
				initial_state = child
				print("[StateMachine] initial_state resolved to first child: ", child.name)
				break

	for child: Node in get_children():
		if child is State:
			states[child.name] = child
			child.player = player
			child.state_machine = self
			child.init()
			print("[StateMachine] Registered state: ", child.name, " | player set: ", child.player != null)

	print("[StateMachine] Total states: ", states.size())

	if initial_state:
		current_state = initial_state
		current_state.enter()
		print("[StateMachine] Entered initial state: ", current_state.name)
	else:
		push_error("[StateMachine] No initial state found!")


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
