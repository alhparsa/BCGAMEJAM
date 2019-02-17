extends KinematicBody2D



var motion = Vector2()

func _physics_process(delta):
	
	motion.y +=20
	
	if Input.is_action_pressed("ui_right"):
		motion.x = 100
		$AnimatedSprite.play()
	elif Input.is_action_pressed("ui_left"):
		motion.x = -100
		$AnimatedSprite.play()
	
	else:
		motion.x = 0
		
	if Input.is_action_pressed("ui_up"):
		$AnimatedSprite.play()
		motion.y = -100
	
	elif Input.is_action_pressed("ui_down"):
		$AnimatedSprite.play()
		motion.y = 100
	#else:
	#	motion.y = 0	
	
	move_and_slide(motion)
	pass
