extends Node2D

var player : Node2D
@onready var collision_shape_2d: CollisionShape2D = $cameraZone/CollisionShape2D
@onready var camera: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player != null:
		camera.global_position = player.global_position

func clamp_to_area():
	pass

func _on_camera_zone_area_entered(area: Area2D) -> void:
	print("[Camera]: DETECTED PLAYER")
	player = area.get_parent()

func _on_camera_zone_area_exited(area: Area2D) -> void:
	print("[Camera]: DETECTED PLAYER LEAVING")
	player = null
