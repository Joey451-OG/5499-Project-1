extends Node

enum PlayerState {IDLE, SWIMING, DROWNED}

var points := 0
var p_state : PlayerState = PlayerState.IDLE
var current_abilities := {
	"speed" : false,
	"higher_lc" : false, # Higher lung capacity
}
