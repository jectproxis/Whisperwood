extends Area2D

#Grants the dash ability and despawns
func _on_body_entered(_body):
	PlayerData.can_dash = true
	queue_free()
