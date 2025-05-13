class_name PlayerState
extends State

#region states
enum PlayerStates {
	IDLE, #DONE
	WALK, #DONE
	JUMP, #DONE
	APEX, #DONE
	FALL, #DONE
	LAND, #DONE
	DASH, #DONE
	ATTACK_1, #DONE
	ATTACK_2, #FIXME projeto de combo ou frame data
	ATTACK_3, #FIXME projeto de combo ou frame data
	ATTACK_4, #FIXME projeto de combo ou frame data
	CROUCH, #DONE
	CROUCH_IDLE, #DONE
	CROUCH_WALK, #DONE
	CROUCH_UP, #DONE
	GRAB, #DONE
	LEDGE_GRAB, #DONE
	DIE, #DONE
	HURT, #DONE
	ROLL, #DONE
	SHIELD_UP, #DONE
	SHIELD, #DONE
	SHIELD_BASH, #DONE
	WALL_SIDE, #TODO projeto de colisões
	WIN, #TODO projeto de colisões
	LADDERS, #TODO projeto de colisões
	TALK, #TODO projeto de colisões
	PUSH, #TODO projeto de colisões
	DRINK, #FIXME projeto de cooldown inventário e UI
	POWER_UP, #TODO projeto de cooldowns inventário e UI
}
#endregion

var player : Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")


static func get_state_name(state : PlayerStates) -> String:
	return PlayerStates.keys()[state]


static func get_state(state_name : String) -> PlayerStates:
	state_name = state_name.to_snake_case().to_upper()
	return PlayerStates.keys().rfind(state_name) as PlayerStates
