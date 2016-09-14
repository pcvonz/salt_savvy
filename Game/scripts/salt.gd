
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
var delta
export var salt_time = 5.0
export var error_range = 2.0
export var win_text = "Congratulations, you pro salter! Press the salt button to continue"
var salting = false
var time = 0
var salted = false 
var error = 1212
var salt_par
var completed = false
var bar
var down = false
var anim_time = 0
var anim_played = false

func _ready():
	set_process(true)
	set_process_input(true)
	#get_node("Label").set_text(str("Salt for ", str(salt_time), " seconds"))
	salt_par = get_node("Particles2D")
	salt_par.set_emitting(false)
	bar = get_node("ProgressBar")

func _process(delta):
	if not completed:
		if(salting == true):
			if(time >= bar.get_max() and down == false):
				down = true
			elif(time <= bar.get_min() and down == true):
				down = false
			
			if(down == false):
				time = time + delta
			else:
				time = time - delta
			bar.set_value(time)
		else:
			bar.set_value(0)
	else:
		anim_time += delta
		if(anim_time > 4):
			if not get_node("../food/AnimationPlayer").is_playing() and not anim_played:
				get_node("../food/AnimationPlayer").play("food exit")
				anim_played = true
		if Input.is_action_pressed("salt"):
			get_node("../food/AnimationPlayer").play("food exit")


func _input(event):
	if(event.is_action_pressed("salt")):
		salting = true
		get_node("Label").set_text("")
		salt_par.set_emitting(false)
	if(event.is_action_released("salt")):
		var error = (bar.get_value() / bar.get_max())* 100
		salting = false
		time = 0
		if(error >= 93):
			salt_par.set_emitting(true)
			completed = true
