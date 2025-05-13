extends EnemyState


func enter(previous_state : String, data := {}) -> void:
	enemy.dying = true
	enemy.play_animation(EnemyStates.DIE)


func physics_update(delta: float) -> void:
	enemy.velocity.x = lerp(enemy.velocity.x, 0.0, enemy.friction * delta)
	
	enemy.velocity.y += enemy.gravity * delta
	enemy.move_and_slide()
