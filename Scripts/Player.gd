extends "res://Scripts/Templates/Mob.gd"

var direction = Vector2.ZERO

onready var world_tiles = GameManager.world.get_node("Tiles")

func _ready():
	GameManager.playerNode = self
	GameManager.loadWorldInfos()
	pass

func _notification(what):
	if what == NOTIFICATION_EXIT_TREE:
		GameManager.saveWorldInfos()
	pass
	
func _input(event):
	if Input.is_action_pressed("Exit"):
		get_tree().quit()
	pass
	
func _physics_process(delta):
	move()
	pass

func move():
	if !GameManager.isConsoleVisible:
		direction.x = (Input.get_action_strength("move_right")-Input.get_action_strength("move_left"))
		direction.y = (Input.get_action_strength("move_down")-Input.get_action_strength("move_up"))
		direction = direction.normalized()
	else:
		direction = Vector2.ZERO
	
	if direction.x != 0 || direction.y != 0:
		$AnimatedSprite.play("walk")
	else: $AnimatedSprite.play("idle")
		
	
	motion.x = (direction.x*speed)
	motion.y = (direction.y*speed)
	pass

func get_pos_in_map():
	return world_tiles.world_to_map(position)
	pass
