class_name Player
extends CharacterBody2D

#region Variables
#region movement set
@export_category("Movement Variables")
@export_group("Walk")
@export_subgroup("Speeds")
@export var walk_speed : float = 60.0
@export var turn_speed : float = 2.0
@export var air_turn_speed : float = 1.0
@export_subgroup("Accelerations")
@export var accel : float = 60.0
@export var air_accel : float = 60.0
@export var friction : float = 20.0
@export var air_friction : float = 10.0
@export_group("Jump")
@export_subgroup("Jump")
@export var jump_impulse : float = 80.0
@export_subgroup("Apex")
@export var apex_margin : float = 0.2
@export var apex_modifier : float = 0.2
@export_subgroup("Fall")
var gravity : float :
	get:
		return ProjectSettings.get_setting("physics/2d/default_gravity")
@export var gravity_modifier : float = 1.5
@export var fall_velocity_threshold : float = 500
@export var terminal_velocity : float = 500
@export_group("Dash")
var can_dash : bool = false
@export var dash_force : float = 200.0
@export var high_speed_recovery : float = 10.0
@export_group("Crouch")
@export_subgroup("Speeds")
@export var crouch_speed : float = 60.0
@export var crouch_turn_speed : float = 2.0
@export_subgroup("Accelerations")
@export var crouch_accel : float = 60.0
@export var crouch_friction : float = 20.0
@export_group("Ledge Grab")
@export var ledge_impulse : float = 400.0
@export_group("Roll")
@export var roll_force : float = 100.0
var is_rolling : bool
#endregion

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var ledge_collision: CollisionShape2D = %LedgeCollision
@onready var floor_check: RayCast2D = %FloorCheck
@onready var wall_check: ShapeCast2D = %WallCheck
@onready var ledge_enabler: ShapeCast2D = %LedgeEnabler
@onready var sprite: Sprite2D = $Sprite
@onready var attack_pivot: Node2D = $AttackPivot
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var shield: Shield = %Shield
#endregion

var hurt : bool
var shield_up : bool :
	get():
		return Input.is_action_pressed("shield_up")


func _ready() -> void:
	attack_pivot.set_disabled(true)


func _unhandled_input(event: InputEvent) -> void:
	if hurt:
		return
	if event.is_action_pressed("jump"):
		%JumpBuffer.start()
	elif event.is_action_released("jump"):
		%CoyoteTime.stop()
	if grab() and is_on_floor():
		return
	if Input.is_action_just_pressed("roll") and not hurt:
		$FSM.state.finished.emit(PlayerState.get_state_name(PlayerState.PlayerStates.ROLL).to_pascal_case())
	if event.is_action_pressed("attack"):
		%AttackBuffer.start()
	#if event.is_action_pressed("shield_up"):
		#shield_up = true
		##%ShieldBuffer.start()
	#if event.is_action_released("shield_up"):
		#shield_up = false


func _physics_process(_delta: float) -> void:
	ledge_collision.disabled = not grab() or ledge_enabler.is_colliding()
	if is_on_floor():
		%CoyoteTime.start()
		can_dash = true


func get_input_direction() -> float:
	var direction := Input.get_axis("move_left", "move_right")
	if direction < 0:
		flip_player(true)
	elif direction > 0:
		flip_player(false)
	return direction


func handle_turn(speed : float, _accel : float, _friction : float, _turn_speed : float, delta: float):
	if sign(get_input_direction()) == sign(velocity.x):
		_speed_acceleration(speed, _accel, _friction, delta)
	else:
		if abs(velocity.x) > walk_speed:
			velocity.x = lerp(velocity.x, get_input_direction() * speed, high_speed_recovery * delta)
		else:
			velocity.x = lerp(velocity.x, get_input_direction() * speed, _turn_speed * delta)


func _speed_acceleration(speed : float, _accel : float, _friction : float, delta: float):
	if get_input_direction():
		if walk_speed - velocity.length() > 0.01:
			velocity.x = lerp(velocity.x, get_input_direction() * speed, _accel * delta)
		else:
			velocity.x = get_input_direction() * speed
	else:
		velocity.x = lerp(velocity.x, 0.0, _friction * delta)


func jump() -> bool:
	var res : bool = not (%JumpBuffer.is_stopped() or %CoyoteTime.is_stopped())
	if res:
		%JumpBuffer.stop()
	return res


func attack() -> bool:
	var res : bool = not %AttackBuffer.is_stopped()
	if res:
		%AttackBuffer.stop()
	return res


#func shield_up() -> bool:
	#var res : bool = not %ShieldBuffer.is_stopped()
	#if res:
		#%ShieldBuffer.stop()
	#return res


func play_animation(state : PlayerState.PlayerStates) -> void:
	animation_player.play("player_animations/" + PlayerState.PlayerStates.keys()[state].to_snake_case())


func grab() -> bool:
	return not floor_check.is_colliding() and wall_check.is_colliding() and not ledge_enabler.is_colliding() and not is_rolling


func flip_player(value : bool):
	sprite.flip_h = value
	var x : float = -1.0 if value else 1.0
	attack_pivot.scale = Vector2(x, 1)
	shield.scale = Vector2(x, 1)


func is_on_floor_check() -> bool:
	return floor_check.is_colliding()


func game_over():
	#FIXME colocar isso no SceneManager?
	get_tree().reload_current_scene()


func _on_hurtbox_hurtbox_destroyed(_hurtbox: Hurtbox) -> void:
	%FSM.state.finished.emit(PlayerState.get_state_name(PlayerState.PlayerStates.DIE).to_pascal_case())


func _on_hurtbox_force_applied(force: Vector2) -> void:
	velocity = force


func _on_hurtbox_hurtbox_hit(hit : Hit) -> void:
	if hit.animate:
		$FSM.state.finished.emit(PlayerState.get_state_name(PlayerState.PlayerStates.HURT).to_pascal_case())
