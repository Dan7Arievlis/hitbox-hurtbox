extends State
class_name EnemyState

#region Enemy States
enum EnemyStates {
	IDLE,
	ATTACK,
	WALK,
	HURT,
	CHASE,
	AIRBORNE,
	DIE,
}
#endregion

var enemy : Enemy

func _ready() -> void:
	await owner.ready
	enemy = owner as Enemy
	assert(enemy != null, "The EnemyState state type must be used only in the player scene. It needs the owner to be a Enemy node.")

static func get_state_name(state : EnemyStates) -> String:
	return EnemyStates.keys()[state]
