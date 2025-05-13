extends PlayerState

func enter(_previous_state_path : String, _data := {}) -> void:
	player.play_animation(PlayerStates.DRINK)


func on_drinked(_effect):
	#TODO add (various) effect!
	pass


func physics_update(delta: float) -> void:
	player.velocity.x = 0.0
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	await player.animation_player.animation_finished
	finished.emit(get_state_name(PlayerStates.IDLE).to_pascal_case())
