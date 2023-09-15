extends Node2D

var shears_scene = preload("res://Scenes/Pickups/shears.tscn")

@onready var pause_menu = $UI/PauseMenu

@onready var hud = $UI/HUD
@onready var retry_screen = $UI/RetryScreen
@onready var player = $"Shade(Player)"

@onready var restart_button = $UI/RetryScreen/RestartButton
@onready var resume_button = $UI/PauseMenu/ResumeButton

func _ready():
	player.damage_taken.connect(_on_player_damage_taken)
	player.player_dead.connect(_on_player_dead)
	player.pause_game.connect(_on_game_paused)
	
	pause_menu.unpause_game.connect(_on_game_unpaused)
	
	if PlayerData.can_dash == false:
		spawn_shears()

func _on_player_damage_taken():
	hud.update_hp()

#Function to spawn the shears pickup at the ShearsSpawn
func spawn_shears():
	var shears_spawn = get_tree().get_first_node_in_group("ShearsSpawn")
	var shears_instance = shears_scene.instantiate()
	
	shears_spawn.add_child(shears_instance)

func _on_player_dead():
	retry_screen.visible = true
	restart_button.grab_focus()

func _on_game_paused():
	pause_menu.visible = true
	resume_button.grab_focus()

func _on_game_unpaused():
	pause_menu.visible = false
