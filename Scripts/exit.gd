extends Area2D

@export var target_scene : String
@export var spawnpoint : String

func _on_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file.call_deferred(target_scene)
		Spawn.spawnpoint = spawnpoint
