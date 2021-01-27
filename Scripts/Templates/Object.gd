extends StaticBody2D

export(int) var life = 3
export(String) var objName = "tree"

func checklife(saveInfos=false):
	if life <= 0:
		GameManager.world.generated_enviroment_objects.remove(GameManager.world.generated_enviroment_objects.find(global_position))
		if saveInfos:
			GameManager.world.saveUpdatedDataInfo([objName, GameManager.world.tiles.world_to_map(position), "Dead"],"ChangedEnviromentObjects")
		call_deferred("queue_free")
	pass
