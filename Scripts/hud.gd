extends Control

@onready var hp = $HP

func _ready():
	hp.text = str(PlayerData.player_hp)

func update_hp():
	hp.text = str(PlayerData.player_hp)
