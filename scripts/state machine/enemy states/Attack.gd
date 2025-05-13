extends EnemyState

@onready var attack_delay: Timer = %AttackDelay
@onready var hitbox: Hitbox = $"../../Hitbox"
@onready var hitbox_attack: Hitbox = $"../../HitboxAttack"

func enter(_previous_state_path : String, _data := {}) -> void:
	enemy.play_animation(EnemyStates.IDLE)
	attack_delay.stop()
	attack_delay.start()
	await attack_delay.timeout
	if not (enemy.dying and enemy.hurt):
		enemy.play_animation(EnemyStates.ATTACK)


func exit():
	hitbox.set_disabled(false)
	hitbox_attack.set_disabled(true)


func physics_update(delta: float) -> void:
	enemy.velocity.x = 0.0
	enemy.velocity.y += enemy.gravity * delta
	enemy.move_and_slide()
	
	await enemy.animation_player.animation_finished
	finished.emit(get_state_name(EnemyStates.IDLE).to_pascal_case())
