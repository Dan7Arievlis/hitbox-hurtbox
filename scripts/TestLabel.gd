extends Label

func _ready() -> void:
	%FSM.connect("fsm_state_changed", _update_label)


func _update_label(_previous_state : String, current_state : String) -> void:
	text = "STATE %s" % current_state.to_upper()
