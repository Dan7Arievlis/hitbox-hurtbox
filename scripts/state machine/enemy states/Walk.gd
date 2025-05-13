extends EnemyState

@onready var walk_timer: Timer = %WalkTimer
var direction : int

func enter(_previous_state_path : String, _data := {}) -> void:
	var wait_time = randf_range(enemy.walk_time_range.x, enemy.walk_time_range.y)
	walk_timer.stop()
	walk_timer.start(wait_time)
	direction = 1 if randf() > 0.5 else -1
	if (enemy.wall_check_is_colliding() or not enemy.floor_check_is_colliding()) and direction == enemy.pivot.scale.x:
		direction *= -1
	enemy.play_animation(EnemyStates.WALK)


func physics_update(delta: float) -> void:
	if enemy.velocity.x - enemy.walk_speed > 10.0:
		enemy.velocity.x = lerp(enemy.velocity.x, enemy.walk_speed, enemy.friction * delta)
	else:
		enemy.velocity.x = enemy.walk_speed
	enemy.velocity.x *= direction
	
	enemy.velocity.y += enemy.gravity * delta
	enemy.move_and_slide()

	if enemy.chase():
		finished.emit(get_state_name(EnemyStates.CHASE).to_pascal_case())


func _on_walk_timer_timeout() -> void:
	if enemy.idle():
		finished.emit(get_state_name(EnemyStates.IDLE).to_pascal_case())


func _on_wall_ckeck_body_entered(_body: Node2D) -> void:
	direction *= -1


func _on_floor_check_body_exited(_body: Node2D) -> void:
	direction *= -1
