extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#export (PackedScene) var Enemy;
var score;

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize();

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit();


func _on_Player_grab():
	if $Enemy.isinhurtbox($Player.position):
		$Enemy.grabbed();
	#	$UDP._sumo()
		$Player.start_throw();
	else:
		$Player.fail_throw();
		#-$Enemy/Hurtbox.position
	#print($Enemy/Hurtbox.position)
	#print($Enemy.position)
	#print($Player.position);
	#$Player.state = "attack";

func _on_Player_throw():
	if($Player.throwstr > 400 or $Player.throwstr < -400):
		$Enemy.thrown($Player.throwstr);
	else:
		$Player.fail_throw();
		$Enemy.idle();

func _on_enemyTimer_timeout():
	$Enemy.reset();
	$Enemy.send_in();


func _on_RootMenu_start_game():
	score = 0;
	$enemyTimer.start();
