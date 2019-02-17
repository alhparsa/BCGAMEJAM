extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var state = "ready"; #ready, attack, retreat, grab
var attackPos = Vector2();
var grabTimer;
var throwstr = 0;
export (int) var speed;
export (Vector2) var origPos;
signal grab;
signal throw;

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	position = origPos;


func _process(delta):
	var velocity = Vector2();
	if state == "attack":
		if (position - attackPos).length() <= delta*speed:
			velocity = Vector2(0,0);
			position = attackPos;
			try_grab();
		else:
			velocity = attackPos - position;
			velocity = velocity.normalized() * speed;
	elif state == "retreat":
		if (position - origPos ).length() <= delta*speed:
			velocity = Vector2(0,0);
			position = origPos;
			ready_self();
		else:
			velocity = origPos - position;
			velocity = velocity.normalized() * speed;

		
	if velocity.length()!=0:
		position += velocity * delta;
	
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func ready_self():
	state = "ready";
	$AnimatedSprite.stop();

func attack(pos):
	attackPos = pos;
	state = "attack";
	$AnimatedSprite.play();
	
func retreat():
	state = "retreat";



func start_throw():
	state = "throwing";
	$ThrowTimer.start();
	throwstr = 0;

func end_throw():
	emit_signal("throw");
	retreat();

func fail_throw():
	print("Throw failed");
	retreat();
	
func try_grab():
	state = "grab";
	emit_signal("grab");
	$AnimatedSprite.stop();

func _input(event):
	if event is InputEventMouseButton and state=="ready":
		attack(event.position);
	elif event is InputEventMouseButton and state=="throwing":
		if event.button_index == BUTTON_LEFT:
			throwstr-=100;
		elif event.button_index == BUTTON_RIGHT:
			throwstr+=100;
