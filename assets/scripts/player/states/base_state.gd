class_name PlayerState extends Node

@export var debug : bool = false

var player_controller : PlayerController

func _ready() -> void:
	print("entering ready...")
	if %StateMachine and %StateMachine is PlayerStateMachine:
		player_controller = %StateMachine.player_controller
