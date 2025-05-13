extends PlayerState

var crouch : bool

func enter(previous_state_path : String, _data := {}) -> void:
	player.hurt = true
	crouch = %CeilingCheck.is_colliding()
	player.play_animation(PlayerStates.HURT)


func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	await player.animation_player.animation_finished
	player.hurt = false
	if crouch:
		finished.emit(get_state_name(PlayerStates.CROUCH).to_pascal_case())
	else:
		finished.emit(get_state_name(PlayerStates.IDLE).to_pascal_case())
