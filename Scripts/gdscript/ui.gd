extends CanvasLayer

@export var score_text := "Sticks: %d"
@export var next_upgd_text := "Next upgrade: %d s."
@onready var end_score: Label = $"EndScreen/Panel/End Score"
@onready var score: Label = $Normal/Score
@onready var next_upgrade: Label = $"Normal/Next Upgrade"
@onready var normal: MarginContainer = $Normal
@onready var end_screen: MarginContainer = $EndScreen
@onready var vignette: ColorRect = $Vignette

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score.text = score_text % Globals.points
	normal.show()
	end_screen.hide()
	vignette.hide()
	
	Globals.pointsUntilUpdate.connect(_on_points_until_update)
	_on_points_until_update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	score.text = score_text % Globals.points
	
	if Globals.p_state == Globals.PlayerState.DROWNED:
		normal.hide()
		end_screen.show()
		end_score.text = score.text
		
	if Globals.p_state == Globals.PlayerState.SWIMING:
		vignette.show()
		vignette.material.set_shader_parameter("alpha",
			lerpf(0.5, 0.9, Globals.vignette_scale)
		)
		print("[ui.gd]: alpha %.2f" % lerpf(0.5, 0.9, Globals.vignette_scale))
		
		vignette.material.set_shader_parameter("inner_radius",
			lerpf(0.7, 0.1, Globals.vignette_scale)
		)
		print("[ui.gd]: inner radius %.2f" % lerpf(0.7, 0.1, Globals.vignette_scale))
		
		vignette.material.set_shader_parameter("outer_radius",
			lerpf(1.5, 1.0, Globals.vignette_scale)
		)
		print("[ui.gd]: outer radius %.2f" % lerpf(1.5, 1.0, Globals.vignette_scale))
	
	if Globals.p_state == Globals.PlayerState.IDLE:
		vignette.hide()
	
func _on_points_until_update():
	#print("[ui.gd]: Points until next upgrade: %d" % Globals.points_until_next_upgrade)
	next_upgrade.text = next_upgd_text % Globals.points_until_next_upgrade
