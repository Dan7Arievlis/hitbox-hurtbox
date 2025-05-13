extends PlayerState

func enter(_previous_state_path : String, _data := {}) -> void:
	player.play_animation(PlayerStates.CROUCH_WALK)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("crouch"):
		finished.emit(get_state_name(PlayerStates.CROUCH_UP).to_pascal_case())
	if event.is_action_pressed("drink"):
		finished.emit(get_state_name(PlayerStates.CROUCH_UP).to_pascal_case(), {"drink" = true})
	if event.is_action_pressed("dash"):
		finished.emit(get_state_name(PlayerStates.DASH).to_pascal_case())


func physics_update(delta: float) -> void:
	player.handle_turn(player.crouch_speed, player.crouch_accel, player.crouch_friction, player.crouch_turn_speed, delta)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if player.shield_up:
		finished.emit(get_state_name(PlayerStates.CROUCH_UP).to_pascal_case(), {"shield" = true})
	if not player.is_on_floor():
		finished.emit(get_state_name(PlayerStates.APEX).to_pascal_case())
	elif player.jump() and not %CeilingCheck.is_colliding():
		finished.emit(get_state_name(PlayerStates.JUMP).to_pascal_case())
	elif player.attack():
		finished.emit(get_state_name(PlayerStates.CROUCH_UP).to_pascal_case(), {"attack" = true})
	elif not player.get_input_direction() and abs(player.velocity.x) < 30:
		finished.emit(get_state_name(PlayerStates.CROUCH_IDLE).to_pascal_case())
		return
