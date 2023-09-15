extends Area2D

var no_turn = false
var damage_dealt = 1
var winter_wisp_hp = 1

@export var move_speed = 50

@onready var right_wall_check = $WorldCollisionCheck/RightWallCheck
@onready var left_wall_check = $WorldCollisionCheck/LeftWallCheck
@onready var ground_check = $WorldCollisionCheck/GroundCheck

#Moves the enemy at a constant speed
func _physics_process(delta):
	global_position.x += move_speed * delta
	
	#If the enemy no longer has ground beneath him, he turns around
	if !ground_check.is_colliding() && no_turn == false:
		turn_around()
	
	#If the enemy hits a wall on his right side he turns around
	elif right_wall_check.is_colliding() && no_turn == false:
		turn_around()
	
	#If the enemy hits a wall on his left side he turns around
	elif left_wall_check.is_colliding() && no_turn == false:
		turn_around()

#Changes the direction of the movement without causing a recurring loop
func turn_around():
	move_speed = -move_speed
	no_turn = true
	
	#Check to make sure enemy doesn't infinitely turn around
	await get_tree().create_timer(1.5).timeout
	no_turn = false

#WinterWisp takes damage
func take_damage(damage_amount):
	winter_wisp_hp = winter_wisp_hp - damage_amount
	
	if winter_wisp_hp <= 0:
		die()

func die():
	queue_free()

#Does damage to the player if hit, then turns the sprite the other direction
func _on_body_entered(body):
	if body is Player && body.dead == false:
		body.take_damage(damage_dealt)
