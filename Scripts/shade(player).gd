extends CharacterBody2D
class_name Player

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_marker_1 = $AttackPoint_1
@onready var attack_marker_2 = $AttackPoint_2

@export var move_speed = 300
@export var jump_force = 500
@export var dash_length = 500

var player_attack_scene = preload("res://Scenes/player_attack.tscn")
var gravity_force = 1000
var move_direction = 0
var animated = false

func _physics_process(delta):
	#Gravity affects player when not on ground
	if !is_on_floor():
		velocity.y += gravity_force * delta
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		jump(jump_force)
	
	if Input.is_action_just_pressed("attack"):
		attack()
		
	if Input.is_action_just_pressed("dash"):
		if animated_sprite.flip_h:
			dash(-dash_length * delta)
		else:
			dash(dash_length * delta)
		
	#Code to move left and right at move_speed
	move_direction = Input.get_axis("move_left","move_right")
	velocity.x = move_direction * move_speed * delta
	
	#Flips sprite to the direction the player is facing
	if move_direction != 0:
		animated_sprite.flip_h = (move_direction == -1)
	
	move_and_slide()
	update_animations(move_direction)

#Player jumps with the power of force
func jump(force):
	velocity.y += -force

#Looping animations play when player action isn't happening
func update_animations(direction):
	#If Player is on floor, either idle or run will play
	if is_on_floor() && animated == false:
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("running")
	#If player is not on floor, either jump or fall animation will play
	elif !is_on_floor() && animated == false:
		if velocity.y < 0:
			animated_sprite.play("jumping")
		else:
			animated_sprite.play("falling")

#Player attack animation plays and hitbox spawns
func attack():
	#Checks to see if animated is false so that actions don't override each other
	if animated == false:
		animated = true
		
		#Sets the attack point to the proper side of the sprite
		var attack_point
		if animated_sprite.flip_h == true:
			attack_point = attack_marker_2
		else:
			attack_point = attack_marker_1
		
		#Attack plays and attack area is spawned
		animated_sprite.play("attack")
		var player_attack = player_attack_scene.instantiate()
		attack_point.add_child(player_attack)
	
		await animated_sprite.animation_finished
		animated = false
		player_attack.queue_free()

func dash(length):
	if animated == false:
		animated = true
		
		velocity.y = 0
		gravity_force = 0
		
		animated_sprite.play("dashing")
		
		await animated_sprite.animation_finished
		velocity.x += length
		animated_sprite.play("rematerialize")
		
		move_and_slide()
		
		await animated_sprite.animation_finished
		animated = false
		gravity_force = 1000
