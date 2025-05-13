extends PlayerState

var attack : bool
var shield : bool
var drink : bool

func enter(previous_state_path : String, data := {}) -> void:
	if %CeilingCheck.is_colliding():
		finished.emit(get_state_name(PlayerStates.CROUCH_IDLE).to_pascal_case())
		return
	player.play_animation(PlayerStates.CROUCH_UP)
	attack = Optional.or_else(data.get("attack"), false)
	shield = Optional.or_else(data.get("shield"), false)
	drink = Optional.or_else(data.get("drink"), false)


func physics_update(delta: float) -> void:
	player.velocity.x = lerp(player.velocity.x, 0.0, player.crouch_friction * delta)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(get_state_name(PlayerStates.APEX).to_pascal_case())
		return
	await  player.animation_player.animation_finished
	if attack:
		finished.emit(get_state_name(PlayerStates.ATTACK_1).to_pascal_case())
		return
	if drink:
		finished.emit(get_state_name(PlayerStates.DRINK).to_pascal_case())
		return
	if shield:
		finished.emit(get_state_name(PlayerStates.SHIELD_UP).to_pascal_case(), {"crouch" : true})
		return
	finished.emit(get_state_name(PlayerStates.IDLE).to_pascal_case())
