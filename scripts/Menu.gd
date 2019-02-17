extends Node2D

var index = 0
var selectPos
var state;
signal start_game;

func _ready():
	set_process_input(true)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	selectPos = $Selection.position
	$Background.hide();
	state = "selecting";

func _input(event):
	if event.is_action("ui_up") && event.is_pressed() && !event.is_echo() && state == "selecting":
		if(index != 0):
			index -= 1
			selectPos.y -= 75
			$Selection.position.y = selectPos.y
			
	if event.is_action("ui_down") && event.is_pressed() && !event.is_echo() && state == "selecting":
		if(index != 3):
			index += 1
			selectPos.y += 75
			$Selection.position.y = selectPos.y
			
	if event.is_action("ui_accept") && event.is_pressed() && !event.is_echo():
		if state == "selecting":
			if (index == 0):
				print("New Game");
				emit_signal("start_game");
				state = "ingame";
				hide();
			if (index == 1):
				print("Options")
			if (index == 2):
				print("Gameplay")
				$Background.show();
				state = "gameplay";
			if(index == 3):
				get_tree().quit()
		elif state == "gameplay":
			$Background.hide();
			state = "selecting";

	