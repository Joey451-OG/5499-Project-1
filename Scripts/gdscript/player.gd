extends CharacterBody2D


@export var VELCOCITY_IMPULSE := 300.0
@export var DRAG := 1.1
@export var lung_capacity_in_seconds := 10

var isUnderWater := true

@onready var sprite: Sprite2D = $Sprite2D
@onready var lung_timer: Timer = $lungTimer
@onready var lung_indicator: Line2D = $Sprite2D/lungIndicator

func _process(delta: float) -> void:
	sprite.scale = Vector2(1, 1) if is_in_range(rad_to_deg(rotation), -90, 90) else Vector2(-1, -1)
	
	if lung_timer.is_stopped() and isUnderWater:
		lung_timer.start(lung_capacity_in_seconds)
	
	lung_indicator.scale.x = 1 - (( lung_timer.wait_time - lung_timer.time_left ) / lung_timer.wait_time)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	#print(sprite.get_rect().has_point(to_local(get_global_mouse_position())))
	if not sprite.get_rect().has_point(to_local(get_global_mouse_position())):
		look_at(get_global_mouse_position())
	
	velocity = transform.x * Input.get_action_strength("swim") * VELCOCITY_IMPULSE
	
	#sinking
	if not Input.is_action_pressed("swim"):
		velocity.y += VELCOCITY_IMPULSE * 0.5
		

	move_and_slide()

# Checks if value is in range (min, max) (exclusive)
func is_in_range(value: float, min: float, max: float) -> bool:
	#print("Value: %.2f: %s" % [value, min < value and value < max])
	return min < value and value < max


func _on_lung_timer_timeout() -> void:
	print("[LUNG TIMER]: Player Drowned!")
