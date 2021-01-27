extends Position2D

onready var playerHand = $Hand
onready var player = get_parent()

var rotation_speed = 40

func _physics_process(delta):
	playerHand()
	changeTileSp(GameManager.UI.selectedTile)
	pass

func playerHand():
	rotate(deg2rad(self.get_angle_to(get_global_mouse_position())*rotation_speed))
	if playerHand.global_position.x < player.position.x:
		player.get_node("AnimatedSprite").flip_h = true
	else:
		player.get_node("AnimatedSprite").flip_h = false
	pass

#função que troca imagem do objeto que podemos colocar 
func changeTileSp(tileIndex):
	var tex = load(str("res://Sprites/GroundTiles/", GameManager.TILENAMES[tileIndex]))
	playerHand.get_node("Sprite").texture.atlas = tex 
	pass
