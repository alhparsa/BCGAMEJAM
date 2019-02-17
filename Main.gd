extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (PackedScene) var Enemy;
var score;

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize();
	score = 0;
	$enemyTimer.start();

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Player_grab():
	if ($Player.position-0.25*$Enemy/Hurtbox.position-$Enemy.position).length() <= 75:
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
	var mob = Enemy.instance();
	add_child(mob);
	mob.send_in();
