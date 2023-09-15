extends Control

#When quit is pressed you go back to the menu scene.
func _on_quit_button_pressed():
	get_tree().quit()

#When restart button is pressed scene is reloaded
func _on_restart_button_pressed():
	get_tree().reload_current_scene()
	
	PlayerData.player_hp = PlayerData.starting_player_hp
