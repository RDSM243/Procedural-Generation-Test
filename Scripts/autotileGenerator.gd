extends Node

var blockTiles = preload("res://Tilesets/GroundTile.tres")
var example = 0

var tiles_to_add = [
	"water.tres",
	"desert_sand.png",
	"snow.png"
]

var bms = {}

func _ready():
	add_new_autotiles()
	ResourceSaver.save("res://Tilesets/BlockTiles.tres",blockTiles)
	
	for x in range(16):
		for y in range(12):
			var bitmask = blockTiles.autotile_get_bitmask(example, Vector2(x, y))
			bms[bitmask] = str("Vector2(",x,",",y,")")
	
	print(bms)
	pass
	
func add_new_autotiles():
	for t in tiles_to_add:
		var new_id = blockTiles.get_last_unused_tile_id()
		var tex = load(str("res://Sprites/GroundTiles/", t))
		
		blockTiles.create_tile(new_id)
		blockTiles.tile_set_region(new_id, Rect2(0, 0, 352, 160))
		blockTiles.tile_set_tile_mode(new_id, TileSet.AUTO_TILE)
		blockTiles.tile_set_texture(new_id, tex)
		blockTiles.autotile_set_size(new_id, Vector2(32,32))
		blockTiles.autotile_set_bitmask_mode(new_id, TileSet.BITMASK_3X3_MINIMAL)
		blockTiles.tile_set_name(new_id, str(t, " ", new_id))
		
		var icon_coord = blockTiles.autotile_get_icon_coordinate(example)
		blockTiles.autotile_set_icon_coordinate(new_id, icon_coord)
		
		for x in range(16):
			for y in range(12):
				var bitmask = blockTiles.autotile_get_bitmask(0, Vector2(x,y))
				blockTiles.autotile_set_bitmask(new_id, Vector2(x, y), bitmask)
	
		for s in blockTiles.tile_get_shapes(example):
			blockTiles.tile_add_shape(new_id, s["shape"], s["shape_transform"], s["one_way"], s["autotile_coord"])
	pass
