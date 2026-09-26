extends Node2D
var key_scene : PackedScene = preload("res://Scenes/Key.tscn")
@onready var key_spawn: Marker2D = $KeySpawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.spawnKey.connect(_spawn_key)

func _spawn_key():
	print("[level.gd]: Received spawnKey signal")
	var key : Node2D = key_scene.instantiate()
	call_deferred("add_child", key)
	key.position = key_spawn.position
