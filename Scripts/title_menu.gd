extends Control

@onready var start_button = $StartButton

func _ready():
	start_button.grab_focus()

#Start button starts the game in scene 1
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/SnowyWoodsRooms/room_1.tscn")

#Quit button quits the game
func _on_quit_button_pressed():
	get_tree().quit()
