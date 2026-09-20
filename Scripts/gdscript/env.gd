@tool
extends Sprite2D

enum Tile_State {
	MISSING, 
	BASE, 
	CONNECTING,
	GROUND, 
	GROUND_CONNECTING,
	BREAKABLE_BASE,
	BREAKABLE_CONNECTING,
	BREAKABLE_G_BASE,
	BREAKABLE_G_CONNECTING,
	BROKEN,
	BROKEN_GROUND,
	}

var _missing = preload("res://Assets/DEV/DEV_Missing_Texture.png")
var _base = preload("res://Assets/Sprites/Base_Env_Tile.png")
var _connecting = preload("res://Assets/Sprites/Connecting_Env_Tile.png")
var _ground = preload("res://Assets/Sprites/Base_Ground_Tile.png")
var _ground_connecting = preload("res://Assets/Sprites/Connecting_Ground_Tile.png")
var _breakable_base = preload("res://Assets/Sprites/Breakable_Base_Env_Tile.png")
var _breakable_connecting = preload("res://Assets/Sprites/Breakable_Connecting_Env_Tile.png")
var _breakable_ground_base = preload("res://Assets/Sprites/Breakable_Base_Ground_Tile.png")
var _breakable_ground_connecting = preload("res://Assets/Sprites/Breakable_Connecting_Ground_Tile.png")
var _broken = preload("res://Assets/Asesprite/Broken_Env.png")
var _broken_ground = preload("res://Assets/Sprites/Broken_Ground.png")

@export var state : Tile_State = Tile_State.MISSING :
	set(st):
		state = st
		
		if not is_inside_tree():
			return
		
		match st:
			Tile_State.MISSING:
				texture = _missing
			Tile_State.BASE:
				texture = _base
			Tile_State.CONNECTING:
				texture = _connecting
			Tile_State.GROUND:
				texture = _ground
			Tile_State.GROUND_CONNECTING:
				texture = _ground_connecting
			Tile_State.BREAKABLE_BASE:
				texture = _breakable_base
			Tile_State.BREAKABLE_CONNECTING:
				texture = _breakable_connecting
			Tile_State.BREAKABLE_G_BASE: 
				texture = _breakable_ground_base
			Tile_State.BREAKABLE_G_CONNECTING:
				texture = _breakable_ground_connecting
			Tile_State.BROKEN:
				texture = _broken
			Tile_State.BROKEN_GROUND:
				texture = _broken_ground
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# forces an update for tooling
	state = state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
