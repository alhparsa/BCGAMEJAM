extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (Vector2) var origPos;
export (int) var speed;
var state;
var dest = Vector2();
var spin;
var timer = 0;
var grabshake = 0;
var enemyType = "cameron";
var thrownStr;
var screensize;

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	state = "hidden"
	
	spin = 0;
	$Hurtbox.hide();
	#send_in();
	enemyType = ["cameron","parsak","ari"][randi()%3];
	#hide();
	screensize = get_viewport_rect().size;
	origPos.y = -200;
	origPos.x = screensize.x/2;
	position = origPos;

func _process(delta):
	timer = (timer + delta);
	if timer > 10:
		timer-=10;
	if state == "moving":
		if(position-dest).length() <= speed*delta:
			position = dest;
			idle();
		else:
			var vel = dest - position;
			if(vel.length() > 0):
				vel = vel.normalized() * speed;
			position += vel * delta;
			scale.x = 0.2 + position.y/800;
			scale.y = 0.2 + position.y/800;
	if state == "grabbed":
		if int(timer*20)%2 == 0:
			if(grabshake==1):
				grabshake=0;
				position.x -= 5;
		else:
			if(grabshake==0):
				grabshake=1;
				position.x += 5;
	elif grabshake==1:
		position.x-=5;
		grabshake = 0;
	if state == "thrown":
		position.x += thrownStr * delta;
		rotate(thrownStr*0.1*delta);
		if(position.x < -100 or position.x > 800):
			print("death/reset/ehhhh");
		
		
		
	
func make_hurt_box():
	$Hurtbox.position.x = randi()%400 -200;
	$Hurtbox.position.y = randi()%600 -300;
	$Hurtbox.show();

func isinhurtbox(pos):
	var hitb_center = position;
	hitb_center.x += scale.x*$Hurtbox.position.x;
	hitb_center.y += scale.y*$Hurtbox.position.y;
	if (pos-hitb_center).length() <= 75:
		return true;
	return false;

func send_in():
	#show();
	state = "moving";
	dest.x = position.x;
	dest.y = screensize.y/2 - 150;
	$AnimatedSprite.animation = enemyType+"_happy";
	$AnimatedSprite.play();
	
func grabbed():
	state = "grabbed";
	$AnimatedSprite.animation = enemyType+"_sad";
	$AnimatedSprite.stop();

func idle():
	state = "idle";
	$AnimatedSprite.animation = enemyType+"_combat";
	$AnimatedSprite.play();
	$hurtDelay.start();
	
func thrown(throwStr):
	scale.x = 0.7;
	state = "thrown";
	thrownStr = throwStr;
	$Hurtbox.hide();
	timer = 0;
	#$AnimatedSprite.animation(enemyType+"_sad");
	#$AnimatedSprite.stop();

func _on_hurtDelay_timeout():
	make_hurt_box();
