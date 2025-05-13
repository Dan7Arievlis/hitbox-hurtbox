extends EnemyState

var last_state : String

func enter(previous_state_path : String, _data := {}) -> void:
	enemy.airborne = true
	enemy.play_animation(EnemyStates.AIRBORNE)
	last_state = Optional.or_else(previous_state_path, get_state_name(EnemyStates.IDLE))


func physics_update(delta: float) -> void:
	enemy.velocity.x = lerp(enemy.velocity.x, 0.0, enemy.air_friction * delta)
	
	enemy.velocity.y += enemy.gravity * delta
	enemy.move_and_slide()
	
	if enemy.is_on_floor():
		enemy.airborne = false
		finished.emit(last_state.to_pascal_case())
