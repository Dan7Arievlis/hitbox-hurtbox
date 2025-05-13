extends PlayerState


func enter(previous_state : String, data := {}) -> void:
	player.play_animation(PlayerStates.DIE)


func physics_update(delta: float) -> void:
	player.velocity.x = lerp(player.velocity.x, 0.0, player.friction * delta)
	
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
