extends Node2D

var locket_scene = preload("res://Scenes/Pickups/locket.tscn")

func _ready():
	#If player hasn't already collected the locket the locket spawns
	if PlayerData.can_double_jump == false:
		spawn_locket()

#Function that spawns locket into the scene at the LocketSpawn marker
func spawn_locket():
	var locket_spawn = get_tree().get_first_node_in_group("LocketSpawn")
	var locket_instance = locket_scene.instantiate()
	
	locket_spawn.add_child(locket_instance)
