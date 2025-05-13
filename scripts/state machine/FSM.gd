class_name FSM
extends Node

@export var initial_state : State = null

@onready var state : State = initial_state if initial_state else get_child(0)

signal fsm_state_changed(previous_state : String, current_state : String)

func _ready() -> void:
	#get_children().map(func(n): return n.name).map(func(s : String): print("const %s = '%s'" % [s.to_snake_case().to_upper(), s.to_pascal_case()]))
	
	for state_node : State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)
	
	await owner.ready
	state.enter(state.name)
	fsm_state_changed.emit("", state.name)


func _transition_to_next_state(target_state_path : String, data : Dictionary = {}) -> void:
	if not has_node(target_state_path):
		printerr(owner.name + ": Trying to transition to state " + target_state_path + " but it does not exist.")
		return
	
	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path) as State
	state.enter(previous_state_path, data)
	fsm_state_changed.emit(previous_state_path, state.name)


func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)
