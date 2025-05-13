extends PlayerState

var crouch : bool
var previous_state : String

func enter(previous_state_path : String, _data := {}) -> void:
	player.is_rolling = true
	previous_state = previous_state_path
	if previous_state_path != name:
		crouch = ["Crouch", "CrouchWalk", "CrouchIdle"].has(previous_state_path)
	player.play_animation(PlayerStates.ROLL)


func physics_update(delta: float) -> void:
	var direction = -1 if %Sprite.flip_h else 1
	player.velocity.x = player.roll_force * direction
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	await player.animation_player.animation_finished
	player.is_rolling = false
	if crouch:
		finished.emit(get_state_name(PlayerStates.CROUCH_IDLE).to_pascal_case())
		return
	finished.emit(get_state_name(PlayerStates.CROUCH_UP).to_pascal_case())
