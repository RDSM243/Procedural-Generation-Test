extends Control

onready var inputBox = $input
onready var outputBox = $output
onready var command_handler = $commandHandler

var commandHistoryLine = GameManager.command_history.size()

func _input(event):
	if Input.is_action_just_pressed("toggle_console"):
		visible = !visible
		if visible: 
			inputBox.grab_focus()
			inputBox.text = ""
	GameManager.isConsoleVisible = visible
	
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_UP:
			goto_command_history(-1)
		elif event.scancode == KEY_DOWN:
			goto_command_history(1)
	pass

func goto_command_history(offset):
	commandHistoryLine += offset
	if commandHistoryLine >= GameManager.command_history.size(): commandHistoryLine = 0
	elif commandHistoryLine < 0: commandHistoryLine = GameManager.command_history.size()-1  
	if commandHistoryLine < GameManager.command_history.size() && GameManager.command_history.size() > 0:
		inputBox.text = GameManager.command_history[commandHistoryLine]
		inputBox.call_deferred("set_cursor_position", 99999999)
	pass

func proccess_command(text):
	var words = text.split(" ", false)
	words = Array(words)
	
	if words.size() == 0:
		return
	
	GameManager.command_history.append(text)
	
	var command_word = words.pop_front()
	
	for c in command_handler.VALID_COMMANDS:
		if c[0] == command_word:
			if words.size() != c[1].size():
				output_text(str('Failure executing command "', command_word, '", "expected', c[1].size(), ' parameters'))
				return
			for i in range(words.size()):
				if !check_type(words[i], c[1][i]):
					output_text(str('Failure executing command "', command_word, '", "parameter ', (i+1), '("',words[i],'") is of the wrong type'))
			output_text(command_handler.callv(command_word, words))
			return
			
	output_text(str('Command "', command_word, '" does not exist.'))
	pass

func check_type(string, type):
	if type == command_handler.ARG_INT:
		return string.is_valid_integer()
	if type == command_handler.ARG_FLOAT:
		return string.is_valid_float()
	if type == command_handler.ARG_STRING:
		return true
	if type == command_handler.ARG_BOOL:
		return(string == "true" or string == "false")
	return false
	pass

func output_text(text):
	outputBox.text = str(outputBox.text, "\n", text)
	outputBox.set_v_scroll(INF)
	pass

func output_clear():
	outputBox.text = 'Debug Console'
	pass

func _on_input_text_entered(new_text):
	inputBox.clear()
	proccess_command(new_text)
	pass # Replace with function body.
