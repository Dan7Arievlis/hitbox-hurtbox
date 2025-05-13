extends PlayerState

var move : bool = false

func enter(_previous_state_path : String, _data := {}) -> void:
	player.play_animation(PlayerStates.LEDGE_GRAB)


func on_can_jump():
	player.velocity.y = -player.ledge_impulse * 5
	move = true


func physics_update(delta: float) -> void:
	if move:
		player.handle_turn(player.walk_speed, player.air_accel, player.air_friction, player.air_turn_speed, delta)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	await player.animation_player.animation_finished
	move = false
	finished.emit(get_state_name(PlayerStates.IDLE).to_pascal_case())
