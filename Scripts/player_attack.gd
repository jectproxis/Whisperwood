extends Area2D

var damage_dealt = 1


func _on_area_entered(area):
	area.take_damage(damage_dealt)
