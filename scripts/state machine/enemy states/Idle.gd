extends EnemyState

@onready var idle_timer: Timer = %IdleTimer

func enter(_previous_state_path : String, _data := {}) -> void:
	var wait_time = randf_range(enemy.idle_time_range.x, enemy.idle_time_range.y)
	idle_timer.stop()
	idle_timer.start(wait_time)
	enemy.play_animation(EnemyStates.IDLE)


func physics_update(delta: float) -> void:
	enemy.velocity.x = lerp(enemy.velocity.x, 0.0, enemy.friction * delta)
	enemy.velocity.y += enemy.gravity * delta
	enemy.move_and_slide()

	if enemy.chase():
		finished.emit(get_state_name(EnemyStates.CHASE).to_pascal_case())


func _on_idle_timer_timeout() -> void:
	if enemy.walk():
		finished.emit(get_state_name(EnemyStates.WALK).to_pascal_case())
