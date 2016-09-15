
extends Spatial

# member variables here, example:
# var a=2
# var b="textvar"
var obs

func _ready():
	get_node("Spatial/level/col").connect("input_event", self, "play_level_one", [get_node("Spatial/level/col")])
	obs = get_node("Observer")
func play_level_one(camera, event, click_pos, click_normal, shape_idx, object):
	var dist = obs.get_global_transform().origin.distance_to(object.get_global_transform().origin)
	if(event.is_action_pressed("click") and dist < 4):
		get_tree().change_scene("res://scenes/level1.tscn")