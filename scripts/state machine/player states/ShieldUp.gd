extends PlayerState

var data := {}

func enter(previous_state_path : String, _data := {}) -> void:
	player.play_animation(PlayerStates.SHIELD_UP)
	data = _data


func exit():
	player.shield.set_disabled(true)


func physics_update(delta: float) -> void:
	player.velocity.x = lerp(player.velocity.x, 0.0, player.friction * delta)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	await player.animation_player.animation_finished
	finished.emit(get_state_name(PlayerStates.SHIELD).to_pascal_case(), data)
