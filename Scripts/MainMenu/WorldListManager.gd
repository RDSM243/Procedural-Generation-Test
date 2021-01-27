extends VBoxContainer

#"pressed", self, "_on_LoadBtn_pressed"

onready var worldContainer = load("res://Nodes/MainMenu/WorldContainer.tscn")

var worldFiles = []

func _ready():
	#capturando arquivos na pasta de mundos
	worldFiles = GameManager.get_files_in_directory(GameManager.worldsFolderDir)
	
	#gerando lista com os mundos da pasta "Worlds"
	for world in worldFiles:
		var dir = Directory.new()
		if dir.file_exists(str(GameManager.worldsFolderDir,"/",world)):
			var worldData = GameManager.get_file(str(GameManager.worldsFolderDir,"/",world))
			var tempWorldContainer = worldContainer.instance()
			
			#verifica se o aquivo tem algo de errado para remove-lo
			if worldData != null:
				tempWorldContainer.get_node("WorldNameTxt").text = worldData["WorldName"]
				tempWorldContainer.worldSeed = worldData["WorldSeed"]
				add_child(tempWorldContainer)
			else:
				dir.remove(str(GameManager.worldsFolderDir,"/",world))
	pass

func loadWorld(worldSeed, worldName):
	GameManager.worldSeed = worldSeed
	GameManager.worldName =  worldName
	
	get_tree().change_scene("res://Scenes/Game.tscn")
	pass
