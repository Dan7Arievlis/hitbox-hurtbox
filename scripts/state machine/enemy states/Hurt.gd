extends EnemyState

@onready var attack_delay: Timer = %AttackDelay

func enter(_previous_state_path : String, _data := {}) -> void:
	attack_delay.stop()
	enemy.play_animation(EnemyStates.HURT)
	enemy.hurt = true


func physics_update(delta: float) -> void:
	if enemy.is_on_floor():
		enemy.velocity.x = lerp(enemy.velocity.x, 0.0, enemy.friction * delta)
	else:
		enemy.velocity.x = lerp(enemy.velocity.x, 0.0, enemy.air_friction * delta)
	
	enemy.velocity.y += enemy.gravity * delta
	enemy.move_and_slide()
	
	await enemy.animation_player.animation_finished
	enemy.hurt = false
	finished.emit(get_state_name(EnemyStates.IDLE).to_pascal_case())
