@tool
extends Control

enum CENTERSHAPE {NONE, DOT, CROSS, DIAMOND}

@export_group("Effect")
@export var show_segments: bool = true : set = set_show_segments
@export var show_center: bool = true : set = set_show_center

@export_group("Effect Settings")
@export var color: Color = Color.WHITE : set = set_crosshair_color
@export_subgroup("Segments")
@export var radius: float = 30.0 : set = set_crosshair_radius
@export var thickness: float = 1.0 : set = set_crosshair_thickness
@export var gap_angle: float = 45.0 : set = set_crosshair_gap_angle
@export var segments: int = 32 : set = set_crosshair_segments
@export_subgroup("Center")
@export var center_shape: CENTERSHAPE = CENTERSHAPE.DOT : set = set_center_shape
@export var center_size: float = 3.0 : set = set_center_size
@export var center_thickness: float = 2.0 : set = set_center_thickness

func _draw() -> void:
	if show_segments:
		draw_circle_crosshair()
	if show_center:
		draw_center_shape()

func draw_circle_crosshair() -> void:
	var gap_rad = deg_to_rad(gap_angle)
	
	var arc_segments = [
		[gap_rad/2, PI/2-gap_rad/2], # bottom-right
		[PI/2+gap_rad/2, PI-gap_rad/2], # bottom-left
		[PI+gap_rad/2, 3*PI/2-gap_rad/2], # top-left
		[3*PI/2+gap_rad/2, 2*PI-gap_rad/2] # top-right
	]
	
	for arc in arc_segments:
		var start_angle = arc[0]
		var end_angle = arc[1]
		var points = []
		var angle_step = (end_angle - start_angle) / segments
		
		for i in range(segments + 1):
			var angle = start_angle + i * angle_step
			var point = Vector2(radius * cos(angle), radius * sin(angle))
			points.append(point)
			
			if points.size() > 1:
				draw_polyline(points, color, thickness, true)

func draw_center_shape() -> void:
	match center_shape:
		CENTERSHAPE.NONE:
			pass
		CENTERSHAPE.DOT:
			# Filled circle
			draw_circle(Vector2.ZERO, center_size, color)
		CENTERSHAPE.CROSS:
			# Horizontal line
			draw_line(Vector2(-center_size, 0), Vector2(center_size, 0), color, center_thickness)
			# Vertical line
			draw_line(Vector2(0, -center_size), Vector2(0, center_size), color, center_thickness)
		CENTERSHAPE.DIAMOND:
			# Filled diamond using draw_polygon
			var points = PackedVector2Array([
				Vector2(0, -center_size),      # top
				Vector2(center_size, 0),       # right
				Vector2(0, center_size),       # bottom
				Vector2(-center_size, 0)       # left
			])
			draw_polygon(points, PackedColorArray([color]))

func update_crosshair() -> void:
	queue_redraw()

# Visibility Setters
func set_show_segments(new_show: bool) -> void:
	show_segments = new_show
	update_crosshair()
	
func set_show_center(new_show: bool) -> void:
	show_center = new_show
	update_crosshair()

# Segment Setters
func set_crosshair_radius(new_radius:float) -> void:
	radius = new_radius
	update_crosshair()
	
func set_crosshair_color(new_color:Color) -> void:
	color = new_color
	update_crosshair()
	
func set_crosshair_thickness(new_thickness:float) -> void:
	thickness = new_thickness
	update_crosshair()
	
func set_crosshair_gap_angle(new_gap_angle:float) -> void:
	gap_angle = new_gap_angle
	update_crosshair()
	
func set_crosshair_segments(new_segments:int) -> void:
	segments = new_segments
	update_crosshair()

# Center Setters
func set_center_shape(new_shape: CENTERSHAPE) -> void:
	center_shape = new_shape
	update_crosshair()

func set_center_size(new_size: float) -> void:
	center_size = new_size
	update_crosshair()

func set_center_thickness(new_thickness: float) -> void:
	center_thickness = new_thickness
	update_crosshair()
