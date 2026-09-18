extends Sprite2D
var ability_unlock_sticks = {
	"speed": 4,
	"higher_lc": 10000
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("swim"):
		for key in ability_unlock_sticks.keys():
			if Globals.points > ability_unlock_sticks[key] and !Globals.current_abilities[key]:
				pass
