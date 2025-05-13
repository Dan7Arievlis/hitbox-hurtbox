extends PlayerState

var jump_cut = func(): return 0.5 if not Input.is_action_pressed("jump") else 1.0

func enter(_previous_state_path : String, _data := {}) -> void:
	player.play_animation(PlayerStates.JUMP)
	player.velocity.y = -player.jump_impulse


func physics_update(delta: float) -> void:
	player.handle_turn(player.walk_speed, player.air_accel, player.air_friction, player.air_turn_speed, delta)
	player.velocity.y *= jump_cut.call()
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if abs(player.velocity.y) < player.apex_margin:
		finished.emit(get_state_name(PlayerStates.APEX).to_pascal_case())
	#if player.is_on_floor():
		#finished.emit(get_state_name(PlayerStates.LAND).to_pascal_case())
