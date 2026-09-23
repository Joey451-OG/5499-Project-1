extends Sprite2D

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if Globals.playerHasKey and Input.is_action_pressed("swim"):
		Globals.playerHasKey = false
		area_2d.set_deferred("monitoring", false)
		collision_shape_2d.set_deferred("disabled", true)
		
		hide()
		
