extends CanvasLayer

onready var playerCamera = GameManager.playerNode.get_node("Camera")
onready var playerGlobalCamera = GameManager.playerNode.get_node("GlobalCamera")

onready var overlay = load("res://Nodes/Interface/debug_overlay.tscn")
onready var TileSpBG = $TileSpBG
onready var TileSp = TileSpBG.get_node("tileSp")

var selectedTile = 0

func _ready():
	GameManager.UI = self
	var tempOverlay = overlay.instance()
	tempOverlay.position = Vector2(10,50)
	tempOverlay.add_stat("Player Position", GameManager.playerNode, "get_pos_in_map", true)
	tempOverlay.add_stat("Player Motion", GameManager.playerNode, "motion", false)
	tempOverlay.add_stat("Time", GameManager, "dayTime", false)
	add_child(tempOverlay)
	pass

func _input(event):
	
	if Input.is_action_just_pressed("global_cam"): $globalCamCK.pressed = !$globalCamCK.pressed
	
	if Input.is_mouse_button_pressed(BUTTON_WHEEL_UP):
		selectedTile -= 1
		if selectedTile < 0: selectedTile = GameManager.TILENAMES.size()-1
		changeTileSp(selectedTile)
	elif Input.is_mouse_button_pressed(BUTTON_WHEEL_DOWN):
		selectedTile += 1
		if selectedTile >= GameManager.TILENAMES.size(): selectedTile = 0
		changeTileSp(selectedTile)
	pass

func _process(delta):
	if $globalCamCK.pressed: playerGlobalCamera.current = true
	else: playerCamera.current = true
	pass

#função que troca imagem do objeto na UI que podemos colocar 
func changeTileSp(tileIndex):
	var tex = load(str("res://Sprites/GroundTiles/", GameManager.TILENAMES[tileIndex]))
	TileSp.texture.atlas = tex 
	pass
