extends Area2D

#When Player enters the pickup it despawns and allows the player to double jump
func _on_body_entered(body):
	if body is Player:
		PlayerData.can_double_jump = true
		queue_free()
