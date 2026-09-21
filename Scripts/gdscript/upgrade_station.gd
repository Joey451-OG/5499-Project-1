extends Sprite2D
var ability_unlock_sticks = {
	"speed": 15,
	"higher_lc": 5
}
var isIndicatorActive : bool = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.pointsUpdate.connect(start_indicator)
	animated_sprite_2d.play("default")

func start_indicator():
	for key in ability_unlock_sticks.keys():
		if Globals.points >= ability_unlock_sticks[key] and !Globals.current_abilities[key]:
			animated_sprite_2d.play("indicating")
			continue

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("swim"):
		for key in ability_unlock_sticks.keys():
			if Globals.points >= ability_unlock_sticks[key] and !Globals.current_abilities[key]:
				print("[update_station.gd]: Unlocked %s!" % key)
				Globals.current_abilities[key] = true
				animated_sprite_2d.play("default")
