extends Node


enum PowerUps {MoreLungCapacity, FasterSwimming}
enum PlayerState {IDLE, SWIMING, DROWNED}

var points := 0
var p_state : PlayerState = PlayerState.IDLE
