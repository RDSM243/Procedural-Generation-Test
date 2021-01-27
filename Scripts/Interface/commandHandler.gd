extends Node

enum {
	ARG_INT,
	ARG_FLOAT,
	ARG_STRING,
	ARG_BOOL
}

const VALID_COMMANDS = [
	["_help",[]],
	["_clear",[]],
	["_set_speed",[ARG_FLOAT]],
	["_tp",[ARG_INT,ARG_INT]],
	["_set_time",[ARG_FLOAT]]
]

func _set_speed(speed):
	speed = float(speed)
	if speed > 0:
		GameManager.playerNode.speed = speed
		return str("Successfully set speed to ", speed)
	return "Speed value must be greater than 0"

func _tp(posX, posY):
	GameManager.playerNode.global_position = Vector2(int(posX)*GameManager.tileWidthSp+GameManager.tileWidthSp/2,int(posY)*GameManager.tileHeightSp+GameManager.tileHeightSp/2)
	return str("Successfully teleported to X: ", posX, " Y: ", posY)
	pass

func _set_time(time):
	time = float(time)*60
	if time < 1440 && time > 0:
		GameManager.skyManager.DayController.seek(time)
		return str("Time Passed to: ", time/60)
	else:
		return "That's not a valid time"
	pass

func _help():
	var helpTxt = ""
	for c in VALID_COMMANDS:
		helpTxt += str(c[0], "\n")
	return helpTxt
	pass

func _clear():
	get_parent().output_clear()
	return ""
	pass
