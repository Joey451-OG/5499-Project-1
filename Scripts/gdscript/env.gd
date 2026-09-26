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
var _broken = preload("res://Assets/Sprites/Broken_Env.png")
var _broken_ground = preload("res://Assets/Sprites/Broken_Ground.png")

@onready var interactable_hit_box: Area2D = $InteractableHitBox
@onready var static_collision: CollisionShape2D = $StaticBody2D/CollisionShape2D

@export var state : Tile_State = Tile_State.MISSING :
	set(st):
		state = st
		
		if not is_inside_tree():
			return
		
		interactable_hit_box.set_deferred("monitoring", false)
		
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
				interactable_hit_box.set_deferred("monitoring", true)
			Tile_State.BREAKABLE_CONNECTING:
				texture = _breakable_connecting
				interactable_hit_box.set_deferred("monitoring", true)
			Tile_State.BREAKABLE_G_BASE: 
				texture = _breakable_ground_base
				interactable_hit_box.set_deferred("monitoring", true)
			Tile_State.BREAKABLE_G_CONNECTING:
				texture = _breakable_ground_connecting
				interactable_hit_box.set_deferred("monitoring", true)
			Tile_State.BROKEN:
				texture = _broken
				interactable_hit_box.set_deferred("monitoring", false)
				static_collision.set_deferred("disabled", true)
			Tile_State.BROKEN_GROUND:
				texture = _broken_ground
				interactable_hit_box.set_deferred("monitoring", false)
				static_collision.set_deferred("disabled", true)
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# forces an update for tooling
	state = state


func _on_interactable_hit_box_area_entered(_area: Area2D) -> void:
	print("[env.gd]: DETECTED TAIL")
	
	if Globals.current_abilities["breaker"]:
		match state:
			Tile_State.BREAKABLE_BASE, Tile_State.BREAKABLE_CONNECTING:
				state = Tile_State.BROKEN
			Tile_State.BREAKABLE_G_BASE, Tile_State.BREAKABLE_G_CONNECTING:
				state = Tile_State.BROKEN_GROUND
