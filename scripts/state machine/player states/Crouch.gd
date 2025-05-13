extends PlayerState

func enter(_previous_state_path : String, _data := {}) -> void:
	player.play_animation(PlayerStates.CROUCH)


func physics_update(delta: float) -> void:
	player.velocity.x = lerp(player.velocity.x, 0.0, player.crouch_friction * delta)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(get_state_name(PlayerStates.APEX).to_pascal_case())
		return
	await  player.animation_player.animation_finished
	finished.emit(get_state_name(PlayerStates.CROUCH_IDLE).to_pascal_case())
