extends "res://StateMachine/StateMachineState.gd"



func weightedSum(a1, w1, a2, w2):
	return a1 * w1 + a2 * w2

func start():
	myEnt.set_animation("Running")

func physics_process(_delta):
	if not myEnt.is_on_floor():
		SM.set_state("Falling")
	else:
		myEnt.velocity.y = 0
	var slope_hack = 1.0
	if abs(myEnt.get_floor_normal().x) > 0.5 :
		slope_hack = 5.0
	#ground movement, automatic decelleration
	if myEnt.get_input_pressed("left"):
		myEnt.velocity.x = weightedSum(myEnt.velocity.x, 0.8, -myEnt.move_speed * slope_hack, 0.2)
	if myEnt.get_input_pressed("right"):
		myEnt.velocity.x = weightedSum(myEnt.velocity.x, 0.8, myEnt.move_speed * slope_hack, 0.2)
	if not(myEnt.get_input_pressed("left") or myEnt.get_input_pressed("right")):
		myEnt.velocity.x = weightedSum(myEnt.velocity.x, 0.8, 0, 0.2)
		if abs(myEnt.velocity.x) <= 10:
			SM.set_state("Idle")
	if myEnt.is_on_floor() and myEnt.jump_released and myEnt.get_input_pressed("up"):
		SM.set_state("Jumping")

func end():
	myEnt.coyote_time = myEnt.default_coyote_time # seconds
