#Pause menu is the only executable node when the scenetree is paused therefore
#all code in the pause menu can't refer to other code
extends Control

signal unpause_game

#To resume the scene tree and turn pause menu invisible
func _on_resume_button_pressed():
	get_tree().paused = false
	
	emit_signal("unpause_game")

#Quits the game entirely
func _on_quit_button_pressed():
	get_tree().quit()

