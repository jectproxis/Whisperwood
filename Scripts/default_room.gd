extends Node2D

@onready var pause_menu = $UI/PauseMenu

@onready var hud = $UI/HUD
@onready var retry_screen = $UI/RetryScreen

@onready var restart_button = $UI/RetryScreen/RestartButton
@onready var resume_button = $UI/PauseMenu/ResumeButton

@onready var player = $"Shade(Player)"

func _ready():
	player.damage_taken.connect(_on_player_damage_taken)
	player.player_dead.connect(_on_player_dead)
	player.pause_game.connect(_on_game_paused)
	
	pause_menu.unpause_game.connect(_on_game_unpaused)

func _on_player_damage_taken():
	hud.update_hp()

func _on_player_dead():
	retry_screen.visible = true
	restart_button.grab_focus()

func _on_game_paused():
	pause_menu.visible = true
	resume_button.grab_focus()

func _on_game_unpaused():
	pause_menu.visible = false
