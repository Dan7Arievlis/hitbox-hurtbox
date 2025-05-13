extends PlayerState

var crouch : bool

func enter(previous_state_path : String, _data := {}) -> void:
	if not player.can_dash or %CeilingCheck.is_colliding():
		finished.emit(previous_state_path)
		return
	if previous_state_path != name:
		crouch = ["Crouch", "CrouchWalk", "CrouchIdle"].has(previous_state_path)
	player.play_animation(PlayerStates.DASH)


func exit():
	player.hurtbox.set_disabled(false)


func physics_update(_delta: float) -> void:
	var direction = -1 if %Sprite.flip_h else 1
	player.velocity.x = player.dash_force * direction
	player.velocity.y = 0
	player.move_and_slide()
	
	await player.animation_player.animation_finished
	player.can_dash = false
	if crouch:
		finished.emit(get_state_name(PlayerStates.CROUCH).to_pascal_case())
		return
	finished.emit(get_state_name(PlayerStates.IDLE).to_pascal_case())
