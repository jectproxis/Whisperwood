extends Area2D

var no_turn = false

@export var move_speed = 50

@onready var right_wall_check = $RightWallCheck
@onready var left_wall_check = $LeftWallCheck
@onready var ground_check = $GroundCheck

#Moves the enemy at a constant speed
func _physics_process(delta):
	global_position.x += move_speed * delta
	
	#If the enemy no longer has ground beneath him, he turns around
	if !ground_check.is_colliding() && no_turn == false:
		turn_around()
	
	#If the enemy hits a wall on his right side he turns around
	if right_wall_check.is_colliding() && no_turn == false:
		turn_around()
	
	#If the enemy hits a wall on his left side he turns around
	if left_wall_check.is_colliding() && no_turn == false:
		turn_around()

#Changes the direction of the movement without causing a recurring loop
func turn_around():
	move_speed = -move_speed
	no_turn = true
	
	#Check to make sure enemy doesn't infinitely turn around
	await get_tree().create_timer(1.5).timeout
	no_turn = false

#Does damage to the player if hit, then turns the sprite the other direction
func _on_body_entered(body):
	if body is Player:
		body.take_damage()
		turn_around()
