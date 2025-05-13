extends PlayerState

func enter(_previous_state_path : String, _data := {}) -> void:
	player.play_animation(PlayerStates.CROUCH_IDLE)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("crouch"):
		finished.emit(get_state_name(PlayerStates.CROUCH_UP).to_pascal_case())
	if event.is_action_pressed("drink"):
		finished.emit(get_state_name(PlayerStates.CROUCH_UP).to_pascal_case(), {"drink" = true})
	#if event.is_action_pressed("shield_up"):
		#finished.emit(get_state_name(PlayerStates.CROUCH_UP).to_pascal_case(), {"shield" = true})
	if event.is_action_pressed("dash"):
		finished.emit(get_state_name(PlayerStates.DASH).to_pascal_case())


func physics_update(delta: float) -> void:
	player.velocity.x = lerp(player.velocity.x, 0.0, player.friction * delta)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(get_state_name(PlayerStates.APEX).to_pascal_case())
	elif player.jump() and not %CeilingCheck.is_colliding():
		finished.emit(get_state_name(PlayerStates.JUMP).to_pascal_case())
	elif player.get_input_direction():
		finished.emit(get_state_name(PlayerStates.CROUCH_WALK).to_pascal_case())
	elif player.attack():
		finished.emit(get_state_name(PlayerStates.CROUCH_UP).to_pascal_case(), {"attack" = true})
	if player.shield_up:
		finished.emit(get_state_name(PlayerStates.CROUCH_UP).to_pascal_case(), {"shield" = true})
