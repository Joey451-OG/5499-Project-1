extends Node2D

@export var overhang := 100

var player : Node2D
@onready var collision_shape_2d: CollisionShape2D = $cameraZone/CollisionShape2D
@onready var camera: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_camera_limits_to_polygon(camera)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player != null:
		camera.global_position = player.global_position
		camera.make_current()
	

func set_camera_limits_to_polygon(current_camera: Camera2D) -> void:
	var shape = collision_shape_2d.shape
	if not shape:
		return
		
	# Get the local bounding rectangle of the shape
	var local_rect: Rect2 = shape.get_rect()
	
	# Convert the local rect boundaries to global coordinates using the node's transform
	var global_rect_position = collision_shape_2d.to_global(local_rect.position)
	var global_rect_end = collision_shape_2d.to_global(local_rect.end)
	
	# Handle cases where the shape or parent might be negatively scaled or flipped
	var min_x = min(global_rect_position.x, global_rect_end.x)
	var max_x = max(global_rect_position.x, global_rect_end.x)
	var min_y = min(global_rect_position.y, global_rect_end.y)
	var max_y = max(global_rect_position.y, global_rect_end.y)

	# Apply the universal bounding box limits to the Camera2D
	current_camera.limit_left = int(min_x - overhang)
	current_camera.limit_right = int(max_x + overhang)
	current_camera.limit_top = int(min_y - overhang)
	current_camera.limit_bottom = int(max_y + overhang)

func _on_camera_zone_area_entered(area: Area2D) -> void:
	print("[camera.gd]: DETECTED PLAYER")
	player = area.get_parent()

func _on_camera_zone_area_exited(_area: Area2D) -> void:
	print("[camera.gd]: DETECTED PLAYER LEAVING")
	player = null
