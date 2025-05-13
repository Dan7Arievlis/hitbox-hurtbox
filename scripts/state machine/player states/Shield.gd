extends PlayerState

var crouch : bool

func enter(previous_state_path : String, data := {}) -> void:
	player.play_animation(PlayerStates.SHIELD)
	crouch = Optional.or_else(data.get("crouch"), false)


func exit():
	player.shield.set_disabled(true)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("crouch"):
		finished.emit(get_state_name(PlayerStates.CROUCH).to_pascal_case())
	if event.is_action_pressed("jump"):
		finished.emit(get_state_name(PlayerStates.JUMP).to_pascal_case())
	if event.is_action_pressed("dash"):
		finished.emit(get_state_name(PlayerStates.DASH).to_pascal_case())
	# Para manter pressionado
	if player.shield_up:
		return
	if event.is_action_pressed("move_left") or event.is_action_pressed("move_right"):
		finished.emit(get_state_name(PlayerStates.WALK).to_pascal_case())


func physics_update(delta: float) -> void:
	player.velocity.x = 0.0
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if player.attack():
		finished.emit(get_state_name(PlayerStates.SHIELD_BASH).to_pascal_case())
	if not player.shield_up:
		if crouch:
			finished.emit(get_state_name(PlayerStates.CROUCH).to_pascal_case())
		else:
			finished.emit(get_state_name(PlayerStates.IDLE).to_pascal_case())
