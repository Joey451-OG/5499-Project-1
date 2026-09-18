extends Node

signal pointsUpdate

enum PlayerState {IDLE, SWIMING, DROWNED}

var points := 0 :
	set(value):
		points = value
		emit_signal("pointsUpdate")

var p_state : PlayerState = PlayerState.IDLE
var current_abilities := {
	"speed" : false,
	"higher_lc" : false, # Higher lung capacity
}

var ability_modifiers := {
	"speed" : 1.5,
	"higher_lc" : 1.5,
}
