extends Control

onready var MainOptions = $MainOptionsBox
onready var WorldOptions = $WorldOptionsBox
onready var WorldCreator = $WorldCreatorBox
onready var WorldList = $WorldOptionsBox/ScrollContainer/VBoxContainer
onready var worldSeedLine = $WorldCreatorBox/ScrollContainer/VBoxContainer/WorldSeed
onready var worldNameLine = $WorldCreatorBox/ScrollContainer/VBoxContainer/WorldName
onready var errorMessage = $WorldCreatorBox/ErrorMenssage

func _on_SinglePlayer_pressed():
	MainOptions.visible = false
	WorldOptions.visible = true
	pass # Replace with function body.

func _on_Options_pressed():
	print("não tem nada")
	pass # Replace with function body.

func _on_Exit_pressed():
	get_tree().quit()
	pass # Replace with function body.

func _on_Back_pressed():
	WorldOptions.visible = false
	MainOptions.visible = true
	pass # Replace with function body.

func _on_CreateWorld_pressed():
	WorldOptions.visible = false
	WorldCreator.visible = true
	pass # Replace with function body.

func _on_WorldOptionBack_pressed():
	WorldOptions.visible = false
	MainOptions.visible = true
	pass # Replace with function body.

func _on_WorldCreatorBack_pressed():
	WorldCreator.visible = false
	WorldOptions.visible = true
	pass # Replace with function body.

func _on_Generate_World_pressed():
	if worldNameLine.text != "":
		GameManager.worldName = worldNameLine.text 
		if worldSeedLine.text.is_valid_integer() && worldSeedLine.text != "":
			GameManager.worldSeed = int(worldSeedLine.text)
		else:
			GameManager.generateSeed()
		
		createWorldFile()
		
		get_tree().change_scene("res://Scenes/Game.tscn")
	else:
		errorMessage.visible = true
	pass # Replace with function body.

func createWorldFile():
	var worldFolderDir = Directory.new()
	
	#criando pasta "TerrainGenerationEngine2" caso ela não exista 
	if !worldFolderDir.dir_exists(GameManager.gameFolderDir):
		worldFolderDir.open("user://")
		worldFolderDir.make_dir(GameManager.gameFolderName)
	
	#criando pasta "Worlds" caso ela não exista 
	if !worldFolderDir.dir_exists(GameManager.worldsFolderDir):
		worldFolderDir.open(GameManager.gameFolderDir)
		worldFolderDir.make_dir("Worlds")
	
	var data = File.new()
	var dataInfo = {
		"WorldName": worldNameLine.text,
		"WorldSeed": int(worldSeedLine.text),
		"PlayerPosition" : Vector2(527,306),
		"DayTime": 6,
		"ChangedTiles": {},
		"ChangedEnviromentObjects": []
	}
	
	data.open(str(GameManager.worldsFolderDir,"/",worldNameLine.text,".dat"),File.WRITE)
	data.store_var(dataInfo)
	data.close()
	pass
