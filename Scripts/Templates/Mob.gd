extends KinematicBody2D

export(int) var life = 100
export(float) var speed = 10
var motion = Vector2.ZERO

func _physics_process(delta):
	if life <= 0:
		queue_free()
		
	motion = move_and_slide(motion)
	pass
