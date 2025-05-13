extends CharacterBody2D
class_name Enemy

#region Variables

@export_group("Speeds")
@export var walk_speed := 100.0
@export var chase_speed := 120.0

@export_group("Timers")
@export var idle_time_range : Vector2 = Vector2(1,7)
@export var walk_time_range : Vector2 = Vector2(3,10)
@export var attack_delay_range : Vector2 = Vector2(0.1,1)

@export_group("Friction")
@export var friction := 50.0
@export var air_friction := 20.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox_attack: Hitbox = $HitboxAttack
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var los: RayCast2D = $AggroArea/LoS
@onready var pivot: Node2D = $Pivot
@onready var wall_check: Area2D = %WallCheck
@onready var floor_check: Area2D = %FloorCheck
var gravity : float :
	get:
		return ProjectSettings.get_setting("physics/2d/default_gravity")

var player : Player

var hurt : bool
var airborne : bool
var last_player_posistion : Vector2
var dying : bool
#endregion

func _ready() -> void:
	hitbox_attack.set_disabled(true)
	los.enabled = false


func _process(_delta: float) -> void:
	if velocity.x > 0 and not hurt:
		sprite.scale.x = 1
		hitbox_attack.scale.x = 1
		pivot.scale.x = 1
	elif velocity.x < 0 and not hurt:
		sprite.scale.x = -1
		hitbox_attack.scale.x = -1
		pivot.scale.x = -1


func _physics_process(_delta: float) -> void:
	if player:
		last_player_posistion = player.global_position
	if los.enabled and player:
		los.target_position = player.global_position - global_position
	
	if not is_on_floor() and not hurt and not airborne:
		%FSM.state.finished.emit(EnemyState.get_state_name(EnemyState.EnemyStates.AIRBORNE).to_pascal_case())


func play_animation(state : EnemyState.EnemyStates) -> void:
	animation_player.play("enemy_animations/" + EnemyState.EnemyStates.keys()[state].to_snake_case())


func idle():
	return is_on_floor() and not hurt


func walk():
	return is_on_floor() and not chase() and not hurt


func chase():
	return los.enabled and los.get_collider() is Player and not (dying or hurt) 


func wall_check_is_colliding():
	return not wall_check.get_overlapping_bodies().is_empty()


func floor_check_is_colliding():
	return not floor_check.get_overlapping_bodies().is_empty()


func _on_hurtbox_hurtbox_destroyed(_hurtbox: Hurtbox) -> void:
	%FSM.state.finished.emit(EnemyState.get_state_name(EnemyState.EnemyStates.DIE).to_pascal_case())


func _on_hurtbox_force_applied(force: Vector2) -> void:
	velocity = force


func _on_hurtbox_hurtbox_hit(_hit : Hit) -> void:
	$FSM.state.finished.emit(EnemyState.get_state_name(EnemyState.EnemyStates.HURT).to_pascal_case())


func _on_aggro_area_body_entered(body: Node2D) -> void:
	los.enabled = true
	if not body is Player:
		return
	player = body as Player
	los.target_position = player.global_position - global_position
	if chase():
		$FSM.state.finished.emit(EnemyState.get_state_name(EnemyState.EnemyStates.CHASE).to_pascal_case())


func _on_aggro_area_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	player = null
	los.target_position = last_player_posistion - global_position
	los.enabled = false
