extends Node2D

var shears_scene = preload("res://Scenes/Pickups/shears.tscn")

func _ready():
	if PlayerData.can_dash == false:
		spawn_shears()

#Function to spawn the shears pickup at the ShearsSpawn
func spawn_shears():
	var shears_spawn = get_tree().get_first_node_in_group("ShearsSpawn")
	var shears_instance = shears_scene.instantiate()
	
	shears_spawn.add_child(shears_instance)
