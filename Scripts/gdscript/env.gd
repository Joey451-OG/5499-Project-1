@tool
extends Sprite2D

enum Tile_State {MISSING, BASE, CONNECTING, GROUND_CONNECTING}
var base = preload("res://Assets/Sprites/Base_Env_Tile.png")
var connecting = preload("res://Assets/Sprites/Connecting_Env_Tile.png")
var ground_connecting = preload("res://Assets/Sprites/Connecting_Ground_Tile.png")
var missing = preload("res://Assets/DEV/DEV_Missing_Texture.png")

@export var state : Tile_State = Tile_State.MISSING :
	set(st):
		state = st
		
		if not is_inside_tree():
			return
		
		match st:
			Tile_State.MISSING:
				texture = missing
			Tile_State.BASE:
				texture = base
			Tile_State.CONNECTING:
				texture = connecting
			Tile_State.GROUND_CONNECTING:
				texture = ground_connecting
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# forces an update for tooling
	state = state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
