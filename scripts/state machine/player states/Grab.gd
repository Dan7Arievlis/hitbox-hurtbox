extends PlayerState

@onready var wall_check: ShapeCast2D = %WallCheck
	
func enter(_previous_state_path : String, _data := {}) -> void:
	player.flip_player(sign((wall_check.get_collision_point(0) - player.global_position).x) < 0.0)
	player.play_animation(PlayerStates.GRAB)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_up") or event.is_action_pressed("jump"):
		finished.emit(get_state_name(PlayerStates.LEDGE_GRAB).to_pascal_case())
	if event.is_action_pressed("move_down") or event.is_action_pressed("crouch") or player.is_on_floor_check():
		player.ledge_collision.disabled = true
		player.position.y += 10
		finished.emit(get_state_name(PlayerStates.APEX).to_pascal_case())


func physics_update(delta: float) -> void:
	player.velocity.x = 0.0
	player.velocity.y += player.gravity * delta
	
	player.move_and_slide()
