extends PlayerState

func enter(_previous_state_path : String, _data := {}) -> void:
	player.play_animation(PlayerStates.APEX)


func physics_update(delta: float) -> void:
	var mod = player.apex_modifier if player.velocity.y < abs(player.apex_margin) and Input.is_action_pressed("jump") else 1.0
	player.handle_turn(player.walk_speed * mod, player.air_accel, player.air_friction, player.air_turn_speed, delta)
	player.velocity.y += player.gravity * delta * player.gravity_modifier
	player.move_and_slide()
	
	if player.velocity.y > player.fall_velocity_threshold:
		finished.emit(get_state_name(PlayerStates.FALL).to_pascal_case())
	if player.is_on_floor():
		finished.emit(get_state_name(PlayerStates.IDLE).to_pascal_case())
	else:
		if player.grab():
			finished.emit(get_state_name(PlayerStates.GRAB).to_pascal_case())
			return
		if player.jump():
			finished.emit(get_state_name(PlayerStates.JUMP).to_pascal_case())
