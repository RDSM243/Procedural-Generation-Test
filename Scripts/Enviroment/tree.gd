extends "res://Scripts/Templates/Object.gd"

func _on_treeHitBox_area_entered(area):
	if area.name == "playerHitBox":
		die(true)
	pass # Replace with function body.

func die(saveInfos=false):
	life = 0
	checklife(saveInfos)
	pass
