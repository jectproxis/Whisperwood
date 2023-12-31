extends Node2D

var locket_scene = preload("res://Scenes/Pickups/locket.tscn")

@onready var pause_menu = $UI/PauseMenu

@onready var hud = $UI/HUD
@onready var retry_screen = $UI/RetryScreen

@onready var resume_button = $UI/PauseMenu/ResumeButton
@onready var restart_button = $UI/RetryScreen/RestartButton
@onready var player = $"Shade(Player)"

func _ready():
	player.damage_taken.connect(_on_player_damage_taken)
	player.player_dead.connect(_on_player_dead)
	player.pause_game.connect(_on_game_paused)
	
	pause_menu.unpause_game.connect(_on_game_unpaused)
	
	#If player hasn't already collected the locket the locket spawns
	if PlayerData.can_double_jump == false:
		spawn_locket()

func _on_player_damage_taken():
	hud.update_hp()

#Function that spawns locket into the scene at the LocketSpawn marker
func spawn_locket():
	var locket_spawn = get_tree().get_first_node_in_group("LocketSpawn")
	var locket_instance = locket_scene.instantiate()
	
	locket_spawn.add_child(locket_instance)

func _on_player_dead():
	retry_screen.visible = true
	restart_button.grab_focus()
	
func _on_game_paused():
	pause_menu.visible = true
	resume_button.grab_focus()

func _on_game_unpaused():
	pause_menu.visible = false

