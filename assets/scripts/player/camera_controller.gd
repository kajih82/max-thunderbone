class_name CameraController extends Node3D

@export var debug : bool = false
@export_category("References")
@export var player_controller : PlayerController
@export var component_mouse_capture : MouseCaptureComponent
@export_category("Camera Settings")
@export_group("Camera Tilt")
@export_range(-90,-60) var tilt_lower_limit : int = -90
@export_range(60,90) var tilt_upper_limit : int = 90
@export_group("Crouch Vertical Movement")
@export var crouch_offset : float = 0.0
@export var crouch_speed : float = 3.0
@export_group("Step Smoothing")
@export var step_speed : float = 8.0

var _rotation : Vector3					# Keep track of player rotation
const DEFAULT_HEIGHT : float = 0.5		# Used for crouching
var _target_height : float				# Used for step smoothing (going up stairs)
var _step_smoothing : bool = false		# Used for step smoothing (going up stairs)
var _offset_height : float = 0.0		# Used for step smoothing (going up stairs)

func _ready() -> void:
	_rotation = player_controller.rotation
	_offset_height = DEFAULT_HEIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_camera_rotation(component_mouse_capture._mouse_input)
	
	if _step_smoothing:
		_target_height = lerp(_target_height, 0.0, step_speed * delta)
		if abs(_target_height) < 0.01:
			_target_height = 0.0
			_step_smoothing = false
		position.y = _offset_height + _target_height

# Used for looking around and rotating player
func update_camera_rotation(input: Vector2) -> void:
	_rotation.x += input.y
	_rotation.y += input.x
	_rotation.x = clamp(_rotation.x, deg_to_rad(tilt_lower_limit), deg_to_rad(tilt_upper_limit))
	
	var _player_rotation = Vector3(0.0,_rotation.y,0.0)
	var _camera_rotation = Vector3(_rotation.x,0.0,0.0)
	
	transform.basis = Basis.from_euler(_camera_rotation)
	player_controller.update_rotation(_player_rotation)
	
	rotation.z = 0.0

# Used for crouching
func update_camera_height(delta:float, direction:int) -> void:
	if _offset_height >= crouch_offset and _offset_height <= DEFAULT_HEIGHT:
		_offset_height = clampf(_offset_height + (crouch_speed * direction) * delta, crouch_offset, DEFAULT_HEIGHT)
	
	if position.y >= crouch_offset and position.y <= DEFAULT_HEIGHT:
		position.y = clampf(position.y + (crouch_speed * direction) * delta, crouch_offset, DEFAULT_HEIGHT)

# Used to smooth out the camera jolt when going up jagged incline like stairs, small plaforms or 
func smooth_step(height_change: float) -> void:
	_target_height -= height_change
	_step_smoothing = true
