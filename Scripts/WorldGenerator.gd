extends Node2D

const WIDTH = 33
const HEIGHT = 28

var mainLayer : OpenSimplexNoise
var temperatureLayer: OpenSimplexNoise
var enviromentLayer : OpenSimplexNoise

var pos: = Vector2.ZERO
var rec: = Rect2()

var pos_chunk = Vector2.ZERO
var old_chunk = Vector2.ZERO

var generated_enviroment_objects = []

var savedTiles = []

onready var tiles = $Tiles

var enviromentObjects = {
	'tree': load("res://Nodes/Enviroment/tree.tscn"),
	'snow_tree': load("res://Nodes/Enviroment/snow_tree.tscn"),
	'cactus': load("res://Nodes/Enviroment/Cactus.tscn")
}

func _ready():
	GameManager.world = self
	mainLayer = create_noise_layer(150)#valor normal period = 400
	temperatureLayer = create_noise_layer(450)
	enviromentLayer = create_noise_layer(1)
	
	rec = Rect2((WIDTH/2*-1),(HEIGHT/2*-1),WIDTH,HEIGHT)
	create_noise()
	pass

func _process(delta : float) -> void:
	pos_chunk = $Chunk.world_to_map(GameManager.playerNode.global_position)
	test_chunk(pos_chunk)
	pass

func create_noise() -> void:
	for i in $Enviroment.get_children():
		#verificando se o enviroment não está dentro do chunk pra assim remove-lo 
		if !GameManager.is_between_positions(i.global_position,$Tiles.map_to_world(rec.position),$Tiles.map_to_world(rec.position+rec.size)):
			i.die()
	tiles.clear()
	
	#capturando informações do arquivo
	var savedData = GameManager.get_file(str(GameManager.worldsFolderDir,"/",GameManager.worldName,".dat"))

	for x in rec.size.x:
		for y in rec.size.y: 
			tiles.set_cell(x + rec.position.x, y + rec.position.y, checkSaveData(Vector2(x + rec.position.x, y + rec.position.y),savedData['ChangedTiles']))
			
	update_chunk()
	pass

func generate_index(tilePos, mainLayer, temperatureLayer, enviromentLayer) -> int:
	if mainLayer < 0.1:
		if temperatureLayer < -0.19:
#			if enviromentLayer < -0.50:
#				generate_enviroment('snow_tree',tiles.map_to_world(tilePos)+Vector2(16,-8))
			return GameManager.TILES.snow
		elif temperatureLayer < 0.13:
#			if enviromentLayer < -0.45:
#				generate_enviroment('tree',tiles.map_to_world(tilePos)+Vector2(16,-8))
			return GameManager.TILES.grass
		else:
#			if enviromentLayer < -0.54:
#				generate_enviroment('cactus',tiles.map_to_world(tilePos)+Vector2(16,-8))
			return GameManager.TILES.desert_sand
	else:
		return GameManager.TILES.water
	pass
	
func test_chunk(pos_chunk) -> void:
	if old_chunk != pos_chunk:
		old_chunk = pos_chunk
		pos = tiles.world_to_map(GameManager.playerNode.global_position)
		rec = Rect2(pos.x - (WIDTH/2),pos.y - (HEIGHT/2),WIDTH,HEIGHT)
		create_noise()
	pass

func update_chunk():
	tiles.update_bitmask_region(rec.position,rec.position+rec.size)
	pass

func create_noise_layer(layerPeriod=64, layerOctaves=3, layerLacunarity=2,  layerSeed=GameManager.worldSeed):
	var noiseLayer = OpenSimplexNoise.new()
	noiseLayer.seed = layerSeed
	noiseLayer.period = layerPeriod
	noiseLayer.octaves = layerOctaves
	noiseLayer.lacunarity = layerLacunarity
	
	return noiseLayer
	pass

func generate_enviroment(enviroment_id, pos:Vector2):
	if checkEnviromentGen(pos, enviroment_id):
		#verificando se o objeto ja foi gerado
		if !generated_enviroment_objects.has(pos):
			var tempObject = enviromentObjects[enviroment_id].instance()
			generated_enviroment_objects.append(pos)
			tempObject.position = pos
			$Enviroment.call_deferred("add_child", tempObject)
	pass

func checkSaveData(tilePos, ChangedTiles):
	if ChangedTiles.has(tilePos):
		return ChangedTiles[tilePos]
	return generate_index(Vector2(tilePos.x,tilePos.y), mainLayer.get_noise_2d(float(tilePos.x), float(tilePos.y)),temperatureLayer.get_noise_2d(float(tilePos.x), float(tilePos.y)),enviromentLayer.get_noise_2d(float(tilePos.x), float(tilePos.y)))
	pass

#verifica se o objeto pode ser gerado
func checkEnviromentGen(objPos:Vector2, enviroment_id:String):
	var dataFile = File.new()
	dataFile.open(str(GameManager.worldsFolderDir,"/",GameManager.worldName,".dat"), File.READ)
	var EnviromentData = dataFile.get_var()['ChangedEnviromentObjects']
	for SavedObj in EnviromentData:
		if SavedObj[1] == tiles.world_to_map(objPos) && SavedObj[2] == "Dead":
			return false
	return true
	pass

#func saveUpdatedDataInfo(changedData,savedDataList=""):
#	var dir = Directory.new()
#	dir.open(GameManager.worldsFolderDir)
#	if dir.file_exists(str(GameManager.worldName,".dat")):
#		var dataFile = File.new()
#		dataFile.open(str(GameManager.worldsFolderDir,"/",GameManager.worldName,".dat"), File.READ)
#		var SavedData = dataFile.get_var()[savedDataList]
#		#removendo informação da posição atual caso ela ja exista
#		for data in SavedData:
#			if data[1] == changedData[1]:
#				SavedData.remove(SavedData.find(data))
#		#adicionando nova informação na lista
#		SavedData.append(changedData)
#		dataFile.close()
#
#		#verificando qual tipo de array possui nova informação
#		if savedDataList == "ChangedTiles":
#			GameManager.saveWorldInfos(GameManager.worldName,GameManager.worldSeed,GameManager.playerNode.position,SavedData)
#		elif savedDataList == "ChangedEnviromentObjects":
#			GameManager.saveWorldInfos(GameManager.worldName,GameManager.worldSeed,GameManager.playerNode.position,[],SavedData)
#	pass

func saveUpdatedDataInfo(changedData,savedDataList=""):
	var dir = Directory.new()
	dir.open(GameManager.worldsFolderDir)
	if dir.file_exists(str(GameManager.worldName,".dat")):
		var dataFile = File.new()
		dataFile.open(str(GameManager.worldsFolderDir,"/",GameManager.worldName,".dat"), File.READ)
		var SavedData = dataFile.get_var()[savedDataList]
		#removendo informação da posição atual caso ela ja exista
		if SavedData.has(changedData[1]):
			SavedData.erase(changedData[1])
		#adicionando nova informação na lista
		SavedData[changedData[1]] = changedData[0]
		dataFile.close()
		
		#verificando qual tipo de array possui nova informação
		if savedDataList == "ChangedTiles":
			GameManager.saveWorldInfos(GameManager.worldName,GameManager.worldSeed,GameManager.playerNode.position,SavedData)
		elif savedDataList == "ChangedEnviromentObjects":
			GameManager.saveWorldInfos(GameManager.worldName,GameManager.worldSeed,GameManager.playerNode.position,[],SavedData)
	pass
	
