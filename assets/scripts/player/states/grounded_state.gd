extends PlayerState

func _on_grounded_state_physics_processing(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and player_controller.is_on_floor():
		player_controller.jump()
		player_controller.state_chart.send_event("onAirborne")
	
	# if the player is airborne without jumping change the state.
	# happens if the player falls without jumping.
	if not player_controller.is_on_floor():
		player_controller.state_chart.send_event("onAirborne")
