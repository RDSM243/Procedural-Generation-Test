extends CanvasModulate

onready var DayController = $AnimationPlayer

func _ready():
	GameManager.skyManager = self
	DayController.play("day_and_night")
	DayController.seek(GameManager.dayTime*60)
	pass

func _process(delta):
	GameManager.dayTime = stepify($AnimationPlayer.current_animation_position/60, 0.01)
	pass
