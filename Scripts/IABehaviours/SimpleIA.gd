extends "res://Scripts/Templates/Mob.gd"

var direction = Vector2.ZERO

func _ready():
	#gerando direção aleatória 
	randomize()
	direction = Vector2(round(rand_range(-1,1)),round(rand_range(-1,1)))
	pass

func _physics_process(delta):
	#movendo personagem para a determinada direção 
	motion = direction*Vector2(speed,speed)
	pass
