extends Panel

var worldSeed = 0 

#quando o botão for pressinado função carrega jogo com informações do arquivo
func _on_LoadBtn_pressed():
	get_parent().loadWorld(worldSeed,$WorldNameTxt.text)
	pass # Replace with function body.

#quando o botão for pressionado função remove arquivo do mundo da pasta worlds
func _on_DeleteBtn_pressed():
	var dir = Directory.new()
	dir.remove(str(GameManager.worldsFolderDir,"/",$WorldNameTxt.text,".dat"))
	queue_free()
	pass # Replace with function body.
