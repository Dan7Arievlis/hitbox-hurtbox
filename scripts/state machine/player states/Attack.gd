extends PlayerState

var next_state : String
var move : bool

func enter(_previous_state_path : String, _data := {}) -> void:
	next_state = ""
	move = false
	%AttackBuffer.stop()
	player.play_animation(get_state(name))


func exit():
	player.attack_pivot.set_disabled(true)


func handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		#TODO combo string!! see doc for link
		if get_state_name(get_state(name) + 1).begins_with("ATTACK"):
			next_state = get_state_name(get_state(name) + 1).to_pascal_case()


func physics_update(delta: float) -> void:
	if name.to_upper() == "ATTACK3" and move:
		var direction = -1 if %Sprite.flip_h else 1
		player.velocity.x = player.dash_force * direction / 5
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, player.friction * delta)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	await player.animation_player.animation_finished
	finished.emit(get_state_name(PlayerStates.IDLE).to_pascal_case())


func on_can_attack():
	if not next_state.is_empty():
		finished.emit(next_state)


func on_move():
	move = not move
