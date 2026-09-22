extends CharacterBody2D

@export var SPEED := 300.0
@export var DRAG := 1.1
@export var LUNG_CAPACITY_IN_SECONDS := 10
@export var item_slow_percent : float = 0.5
@export var ice_spike_penalty : float = 0.1

var isUnderWater := false
var pickup : Node2D = null
var current_lung_capacity_in_seconds : float

var lung_time_left : float = 0.0
var isLungTimerRunning : bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var lung_indicator: Line2D = $Sprite2D/lungIndicator
@onready var item_pivot: Node2D = $Sprite2D/ItemPivot
@onready var interacting_hit_box: Area2D = $interactingHitBox

func _ready() -> void:
	current_lung_capacity_in_seconds = LUNG_CAPACITY_IN_SECONDS

func _process(delta: float) -> void:

	#print(sprite.get_rect().has_point(to_local(get_global_mouse_position())))
	if not sprite.get_rect().has_point(to_local(get_global_mouse_position())):
		look_at(get_global_mouse_position())

	if pickup != null:
		pickup.global_position = item_pivot.global_position
	
	if is_in_range(rad_to_deg(rotation), -90, 90):
		sprite.scale = abs(sprite.scale)
	elif sprite.scale.y > 0:
		sprite.scale.y = -sprite.scale.y
	
	if not isLungTimerRunning and isUnderWater:
		if Globals.current_abilities["higher_lc"]:
			current_lung_capacity_in_seconds = LUNG_CAPACITY_IN_SECONDS
			current_lung_capacity_in_seconds *= Globals.ability_modifiers["higher_lc"]
			
		lung_time_left = current_lung_capacity_in_seconds
		isLungTimerRunning = true
	
	if not isUnderWater and isLungTimerRunning:
		# manually reset needed variables
		isLungTimerRunning = false
		lung_time_left = 0.0
		lung_indicator.scale.x = 0
		Globals.vignette_scale = 0.0
	
	if isLungTimerRunning:
		# manually count down
		lung_time_left -= delta
		var timer_completed_percentage := (( current_lung_capacity_in_seconds - lung_time_left ) / current_lung_capacity_in_seconds)
		lung_indicator.scale.x = 1 - timer_completed_percentage
		Globals.vignette_scale = timer_completed_percentage
		
		# manually stop the timer
		if lung_time_left <= 0:
			isLungTimerRunning = false
			_on_lung_timer_timeout()
	
	for area in interacting_hit_box.get_overlapping_areas():
		if area.has_meta("isAir"):
			isUnderWater = !area.get_meta("isAir")
			#print(isUnderWater)
			
func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	
	velocity = transform.x * Input.get_action_strength("swim") * SPEED
	if Globals.current_abilities["speed"]:
		velocity *= Globals.ability_modifiers["speed"]
	
	if isUnderWater and velocity > Vector2.ZERO and Globals.p_state != Globals.PlayerState.SWIMING:
		Globals.p_state = Globals.PlayerState.SWIMING
	elif not isUnderWater:
		Globals.p_state = Globals.PlayerState.IDLE
	
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
		
	if area.has_meta("isIceSpike") and area.get_meta("isIceSpike"):
		if isLungTimerRunning:
			lung_time_left *= 1.0 - ice_spike_penalty
		
		print("[player.gd]: Just hit Ice Spike")
