extends Node

const tileWidthSp = 32
const tileHeightSp = 32

const gameFolderName = "SurvivalGame"
onready var gameFolderDir = "user://"+gameFolderName
onready var worldsFolderDir = gameFolderDir+"/Worlds"

const TILES = {
	"grass": 0,
	"water" : 1,
	"desert_sand" : 2,
	"snow": 3
}

const TILENAMES = [
	"grass.png",
	"water.tres",
	"desert_sand.png",
	"snow.png"
] 
	
var playerNode = null
var UI = null
var isConsoleVisible = false
var world = null
var skyManager = null
var worldSeed = 0
var worldName = ""
var dayTime = 6

var command_history = []

func generateSeed():
	randomize()
	worldSeed = randi()
	pass

func loadWorldInfos():
	var dir = Directory.new()
	dir.open(GameManager.worldsFolderDir)
	if dir.file_exists(str(worldName,".dat")):
		var savedData = get_file(str(GameManager.worldsFolderDir,"/",worldName,".dat"))
		playerNode.position = savedData['PlayerPosition']
		dayTime = savedData['DayTime']
	pass

func saveWorldInfos(world_name=worldName,world_seed=worldSeed,player_position=GameManager.playerNode.global_position, changed_tiles=[], changed_enviroment_objects=[], day_time=dayTime):
	var dataFile = get_file(str(GameManager.worldsFolderDir,"/",worldName,".dat"))
	
	#se nós não definirmos um parametro para o array changed_tiles
	#nós pegamos o valor armazenado no arquivo
	if changed_tiles.size() <= 0:
		changed_tiles = dataFile["ChangedTiles"]
	if changed_enviroment_objects.size() <= 0:
		changed_enviroment_objects = dataFile["ChangedEnviromentObjects"]
	
	#salvar os dados na variavel data
	var dataInfo = {
		"WorldName": world_name,
		"WorldSeed": world_seed,
		"PlayerPosition": player_position,
		"DayTime": day_time,
		"ChangedTiles": changed_tiles,
		"ChangedEnviromentObjects": changed_enviroment_objects
	}
	
	dataFile = File.new()
	dataFile.open(str(GameManager.worldsFolderDir,"/",world_name,".dat"), File.WRITE)
	dataFile.store_var(dataInfo)
	dataFile.close()
	pass

func get_file(path:String, keyName=""):
	var dataFile = File.new()
	dataFile.open(path, File.READ)
	var fileData
	if keyName != "": fileData = dataFile.get_var()[keyName]
	else: fileData = dataFile.get_var()
	dataFile.close()
	return fileData
	pass

func get_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				files.append(file_name)
			file_name = dir.get_next()
	return files
	pass
	
func is_between_positions(inside_pos:Vector2, pos1:Vector2, pos2:Vector2):
	if (inside_pos.x > pos1.x && inside_pos.x < pos2.x) && (inside_pos.y > pos1.y && inside_pos.y < pos2.y):
		return true
	else:
		return false 
	pass
