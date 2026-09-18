extends CharacterBody2D

@export var SPEED := 300.0
@export var DRAG := 1.1
@export var lung_capacity_in_seconds := 10
@export var item_slow_percent : float = 0.5

var isUnderWater := false
var pickup : Node2D = null

@onready var sprite: Sprite2D = $Sprite2D
@onready var lung_timer: Timer = $lungTimer
@onready var lung_indicator: Line2D = $Sprite2D/lungIndicator
@onready var item_pivot: Node2D = $Sprite2D/ItemPivot
@onready var interacting_hit_box: Area2D = $interactingHitBox

func _process(delta: float) -> void:
	if pickup != null:
		pickup.global_position = item_pivot.global_position
	
	if is_in_range(rad_to_deg(rotation), -90, 90):
		sprite.scale = abs(sprite.scale)
	elif sprite.scale.y > 0:
		sprite.scale.y = -sprite.scale.y
	
	if lung_timer.is_stopped() and isUnderWater:
		if Globals.current_abilities["higher_lc"]:
			lung_capacity_in_seconds *= Globals.ability_modifiers["higher_lc"]
		
		lung_timer.start(lung_capacity_in_seconds)
	
	if not isUnderWater and !lung_timer.is_stopped():
		lung_timer.stop()
	
	lung_indicator.scale.x = 1 - (( lung_timer.wait_time - lung_timer.time_left ) / lung_timer.wait_time)
	
	for area in interacting_hit_box.get_overlapping_areas():
		if area.has_meta("isAir"):
			isUnderWater = !area.get_meta("isAir")
			#print(isUnderWater)
			
func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	#print(sprite.get_rect().has_point(to_local(get_global_mouse_position())))
	if not sprite.get_rect().has_point(to_local(get_global_mouse_position())):
		look_at(get_global_mouse_position())
	
	velocity = transform.x * Input.get_action_strength("swim") * SPEED
	if Globals.current_abilities["speed"]:
		velocity *= Globals.ability_modifiers["speed"]
	
	if velocity > Vector2.ZERO and Globals.p_state != Globals.PlayerState.SWIMING:
		Globals.p_state = Globals.PlayerState.SWIMING
	
	if pickup != null:
		velocity *= 1 - item_slow_percent

	move_and_slide()

# Checks if value is in range (min, max) (exclusive)
func is_in_range(value: float, min: float, max: float) -> bool:
	#print("Value: %.2f: %s" % [value, min < value and value < max])
	return min < value and value < max

func _on_lung_timer_timeout() -> void:
	print("[LUNG TIMER | player.gd]: Player Drowned!")
	Globals.p_state = Globals.PlayerState.DROWNED

func _on_interacting_hit_box_area_entered(area: Area2D) -> void:
	if area.has_meta("isAir"):	
		if pickup != null and area.get_meta("isAir"):
			pickup.queue_free()
			Globals.points += 1
			print("[player.gd]: PLAYER SCORED points: %d" % Globals.points)
		
	if area.has_meta("isPickup"):
		print("[player.gd]: Touched Pickup!")
		area.disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
		pickup = area.get_parent()
