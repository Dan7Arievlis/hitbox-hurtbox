extends EnemyState

@onready var walk_timer: Timer = %WalkTimer
var direction : int

func enter(_previous_state_path : String, _data := {}) -> void:
	var condition : bool = (enemy.wall_check_is_colliding() or not enemy.floor_check_is_colliding()) \
		and sign((enemy.last_player_posistion - enemy.global_position).x) * enemy.pivot.scale.x >= 0
	if condition:
		finished.emit(get_state_name(EnemyStates.IDLE).to_pascal_case())
		return
	enemy.play_animation(EnemyStates.WALK)


func physics_update(delta: float) -> void:
	direction = 1 if (enemy.last_player_posistion - enemy.global_position).x > 0 else -1
	if enemy.velocity.x - enemy.chase_speed > 10.0:
		enemy.velocity.x = lerp(enemy.velocity.x, enemy.chase_speed, enemy.friction * delta)
	else:
		enemy.velocity.x = enemy.chase_speed
	enemy.velocity.x *= direction
	
	enemy.velocity.y += enemy.gravity * delta
	enemy.move_and_slide()
	
	if abs(enemy.los.target_position.length()) <= 40.0:
		finished.emit(get_state_name(EnemyStates.ATTACK).to_pascal_case())
	if abs((enemy.last_player_posistion - enemy.global_position).x) < 20.0 or not enemy.floor_check_is_colliding():
		finished.emit(get_state_name(EnemyStates.IDLE).to_pascal_case())
