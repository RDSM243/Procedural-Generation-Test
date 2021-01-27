extends Sprite

var widthSp = 32
var heightSp = 32

onready var tiles = GameManager.world.get_node("Tiles")

func _process(delta):
	var mousePos = tiles.world_to_map(get_global_mouse_position())
	position = Vector2(round(mousePos.x*widthSp) + widthSp/2,round(mousePos.y*heightSp) + heightSp/2)
	
	changeTileSp(GameManager.UI.selectedTile)
	
	#player não pode colocar tile fora do chunk
	if GameManager.is_between_positions(global_position, tiles.map_to_world(GameManager.world.rec.position),tiles.map_to_world(GameManager.world.rec.position)+tiles.map_to_world(GameManager.world.rec.size)):
		if Input.is_action_pressed("attack"):
			#verificando se o id do tile é igual ao que nós queremos colocar
			if tiles.get_cellv(tiles.world_to_map(position)) != GameManager.UI.selectedTile:
				tiles.set_cellv(tiles.world_to_map(position), GameManager.UI.selectedTile)
				GameManager.world.saveUpdatedDataInfo([GameManager.UI.selectedTile, tiles.world_to_map(position)],"ChangedTiles")
				GameManager.world.update_chunk()
	pass

#função que troca imagem do objeto que podemos colocar 
func changeTileSp(tileIndex):
	var tex = load(str("res://Sprites/GroundTiles/", GameManager.TILENAMES[tileIndex]))
	texture.atlas = tex 
	pass
