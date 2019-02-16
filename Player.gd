extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var state = "ready"; #ready, attack, retreat, grab
var attackPos = Vector2();
var grabTimer;
export (int) var speed;
export (Vector2) var origPos;
signal grab;

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	position = origPos;
	

func _process(delta):
	var velocity = Vector2();
	if state == "attack":
		velocity = attackPos - position;
		velocity = velocity.normalized() * speed;
	elif state == "retreat":
		velocity = origPos - position;
		velocity = velocity.normalized() * speed;
	elif state == "grab":
		grabTimer += delta;
		if grabTimer >= 1:
			state = "retreat";
			$AnimatedSprite.animation = "godot";
	position += velocity * delta;
	if state == "attack" and (position - origPos).length() >= (attackPos - origPos).length():
		position = attackPos;
		state = "grab";
		grabTimer = 0;
		emit_signal("grab");
		$AnimatedSprite.stop();
	if state == "retreat" and (position - attackPos).length() >= (origPos - attackPos).length():
		position = origPos;
		state = "ready";
		$AnimatedSprite.animation = "default";
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
	if event is InputEventMouseButton and state=="ready":
		attackPos = event.position;
		state = "attack";
		$AnimatedSprite.play();
