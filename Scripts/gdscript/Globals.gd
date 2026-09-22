extends Node

signal pointsUpdate
signal pointsUntilUpdate

enum PlayerState {IDLE, SWIMING, DROWNED}

var points := 0 :
	set(value):
		points = value
		emit_signal("pointsUpdate")

var points_until_next_upgrade : int = 5:
	set(value):
		points_until_next_upgrade = value
		emit_signal("pointsUntilUpdate")

var god_mode : bool = true
var vignette_scale : float = 0.0
var p_state : PlayerState = PlayerState.IDLE

var current_abilities := {
	"higher_lc" : false, # Higher lung capacity
	"speed" : false,
	"breaker": false,
}

var ability_modifiers := {
	"speed" : 1.5,
	"higher_lc" : 2.5,
}

func _ready() -> void:
	if god_mode:
		for key in current_abilities.keys():
			current_abilities[key] = true
	
