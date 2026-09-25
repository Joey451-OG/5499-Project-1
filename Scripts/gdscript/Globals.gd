extends Node

signal pointsUpdate
signal pointsUntilUpdate
signal spawnKey

enum PlayerState {IDLE, SWIMING, DROWNED}

@export var ramped_ability_increase_percentage := 0.2

var points := 0 :
	set(value):
		points = value
		emit_signal("pointsUpdate")
		
		if points == 2:
			print("[Globals.gd]: Emitting spawnKey")
			emit_signal("spawnKey")
		
		if points > 25:
			p_state = PlayerState.DROWNED

var points_until_next_upgrade : int = 5:
	set(value):
		points_until_next_upgrade = value
		emit_signal("pointsUntilUpdate")

var god_mode : bool = false
var vignette_scale : float = 0.0
var p_state : PlayerState = PlayerState.IDLE
var added_upgrade_lock := false
var playerHasKey := false

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

func _process(delta: float) -> void:
	_check_for_ramped_abilites()
	
func _check_for_ramped_abilites():
	if current_abilities["breaker"] and not added_upgrade_lock:
		added_upgrade_lock = true
		for key in ability_modifiers.keys():
			ability_modifiers[key] += ramped_ability_increase_percentage
	
