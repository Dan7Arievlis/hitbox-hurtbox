extends PlayerState

func enter(_previous_state_path : String, _data := {}) -> void:
	player.play_animation(PlayerStates.FALL)


func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta * player.gravity_modifier
	player.velocity.y = min(player.velocity.y, player.terminal_velocity)
	player.handle_turn(player.walk_speed, player.air_accel, player.air_friction, player.air_turn_speed, delta)
	player.move_and_slide()
	
	if player.is_on_floor() and not player.grab():
		finished.emit(get_state_name(PlayerStates.LAND).to_pascal_case())
	elif player.grab():
		finished.emit(get_state_name(PlayerStates.GRAB).to_pascal_case())
