extends PlayerState

func enter(_previous_state_path : String, _data := {}) -> void:
	#player.animation_player.play("player_animations/RESET")
	#await  player.animation_player.animation_finished
	player.play_animation(PlayerStates.WALK)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("crouch"):
		finished.emit(get_state_name(PlayerStates.CROUCH).to_pascal_case())
	if event.is_action_pressed("drink"):
		finished.emit(get_state_name(PlayerStates.DRINK).to_pascal_case())
	if event.is_action_pressed("dash"):
		finished.emit(get_state_name(PlayerStates.DASH).to_pascal_case())
	#if event.is_action_pressed("shield_up"):
		#finished.emit(get_state_name(PlayerStates.SHIELD_UP).to_pascal_case())


func physics_update(delta: float) -> void:
	player.handle_turn(player.walk_speed, player.accel, player.friction, player.turn_speed, delta)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if not player.is_on_floor():
		if player.grab():
			finished.emit(get_state_name(PlayerStates.GRAB).to_pascal_case())
			return
		finished.emit(get_state_name(PlayerStates.APEX).to_pascal_case())
	elif player.jump():
		finished.emit(get_state_name(PlayerStates.JUMP).to_pascal_case())
	elif not player.get_input_direction() and abs(player.velocity.x) < 60:
		finished.emit(get_state_name(PlayerStates.IDLE).to_pascal_case())
		return
	elif player.attack():
		finished.emit(get_state_name(PlayerStates.ATTACK_1).to_pascal_case())
	elif player.shield_up:
		finished.emit(get_state_name(PlayerStates.SHIELD_UP).to_pascal_case())
	else:
		if player.grab():
			finished.emit(get_state_name(PlayerStates.GRAB).to_pascal_case())
