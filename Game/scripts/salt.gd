
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
var delta
export var salt_time = 5.0
export var error_range = 2.0
export var win_text = "Congratulations, you pro salter! Press the salt button to continue"
export var amount_needed = 5
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
var food
var curr_food
var count = 0
var label
func _ready():
	set_process(true)
	set_process_input(true)
	#get_node("Label").set_text(str("Salt for ", str(salt_time), " seconds"))
	salt_par = preload("res://scenes/salt_particle.tscn").instance()
	food = preload("res://scenes/chowder.tscn").instance()
	bar = get_node("ProgressBar")
	bar.set_max(rand_range(.2, 1))
	add_food()
	label = get_node("Label")

func _process(delta):
	label.set_text(str("Salted: ", count))
	if amount_needed <= count:
		get_tree().change_scene("res://scenes/main.tscn")
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
		if(anim_time > .75):
			if not curr_food.get_node("AnimationPlayer").is_playing() and not anim_played:
				curr_food.get_node("AnimationPlayer").play("food exit")
				anim_played = true

		if(anim_time > 1.25):
			count += 1
			add_food()
			randomize()
			bar.set_max(rand_range(.2, 1))
			anim_played = false
			anim_time = 0
			completed = false
			error = 100
				

func shoot_salt(speed):
	var salt_amount = 20
	var offset = salt_amount / 2
	for i in range(0, salt_amount):
		var temp_salt = salt_par.duplicate()
		curr_food.add_child(temp_salt)
		temp_salt.set_pos(get_node("Position2D").get_pos()+ Vector2(offset, sin(offset)* 50))
		temp_salt.apply_impulse(temp_salt.get_pos(), (Vector2(0, 1000/speed)))
		offset += 1

func add_food():
	if(curr_food):
		curr_food.queue_free()
	curr_food = food.duplicate()
	print(curr_food.get_pos())
	add_child(curr_food)

func _input(event):
	if(event.is_action_pressed("salt")):
		salting = true
		get_node("Label").set_text("")
	if(event.is_action_released("salt")):
		var error = (bar.get_value() / bar.get_max())* 100
		salting = false
		time = 0
		if(error >= 93 and not completed):
			shoot_salt(bar.get_value())
			completed = true
