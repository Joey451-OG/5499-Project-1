extends Control
@onready var score: Label = $MarginContainer/Score

@export var score_text := "Score: %d"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score.text = score_text % Globals.points


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	score.text = score_text % Globals.points
	
	var camera = get_viewport()
	reparent(camera)
