extends CharacterBody2D
class_name Player

signal damage_taken
signal player_dead
signal pause_game

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_marker_1 = $AttackPoint_1
@onready var attack_marker_2 = $AttackPoint_2

@onready var right_knockback = $RightKnockback
@onready var left_knockback = $LeftKnockback

@export var move_speed = 300
@export var jump_force = 500
@export var dash_length = 500

@export var dash_cooldown_time = 2.5

var player_attack_scene = preload("res://Scenes/PlayerComponents/player_attack.tscn")
var starting_gravity = 1200
var gravity_force = starting_gravity

var move_direction = 0
var jump_cap = 450
var max_fall_speed = 700

var push_force = 500
var knockback_force = 40000
var being_knockbacked = false

var animated = false
var dash_on_cooldown = false
var double_jumped = false

var dead = false

func _ready():
	spawn()

func _physics_process(delta):
	if !dead:
		#Gravity affects player when not on ground
		if !is_on_floor():
			velocity.y += gravity_force * delta
		
		if Input.is_action_just_pressed("jump") && is_on_floor():
			jump(jump_force)
		
		#Allows player to air jump once
		if Input.is_action_just_pressed("jump") && !is_on_floor():
			if double_jumped == false && PlayerData.can_double_jump:
				jump(jump_force)
				double_jumped = true
		
		#Ensures that the air jump variable resets when player touches grass
		if is_on_floor():
			double_jumped = false
		
		if Input.is_action_just_pressed("attack"):
			attack()
			
		if Input.is_action_just_pressed("dash") && PlayerData.can_dash:
			if animated_sprite.flip_h:
				dash(-dash_length * delta)
			else:
				dash(dash_length * delta)
				
		#Can pause game when not dead
		if Input.is_action_just_pressed("pause") && !get_tree().paused:
			get_tree().paused = true
			
			emit_signal("pause_game")
		
		#Makes knockback happen
		if being_knockbacked == true:
			knockback(knockback_force * delta)
		
		#Code to move left and right at move_speed
		if being_knockbacked == false:
			move_direction = Input.get_axis("move_left","move_right")
			velocity.x = move_direction * move_speed * delta
			
			#Flips sprite to the direction the player is facing
			if move_direction != 0:
				animated_sprite.flip_h = (move_direction == -1)
		
		#Puts a cap on the double jump
		if velocity.y < -jump_cap:
			velocity.y = -jump_cap
		
		#Puts a cap on the fall speed
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed
		
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

#Player dash and plays the dash animations
func dash(length):
	#Puts dash on cooldown after the dash happens
	if dash_on_cooldown == false:
		dash_on_cooldown = true
		
		#Player can't attack and dash at the same time
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
			gravity_force = starting_gravity
			animated = false
			
		#Ends dash cooldown
		await get_tree().create_timer(dash_cooldown_time).timeout
		dash_on_cooldown = false

#Spawns the player at the designated spawnpoint
func spawn():
	var spawnpoints = []
	spawnpoints = get_tree().get_nodes_in_group("SpawnPoint")
	
	#Iterates through the spawnpoints in the scene and finds one that matches the target name
	#then sets that as the player spawnpoint
	for spawnpoint in spawnpoints:
		if Spawn.spawnpoint == spawnpoint.name:
			global_position = spawnpoint.global_position
			break

#Player loses health and dies if hp is equal to or less than 0
func take_damage(damage_amount):
	PlayerData.player_hp = PlayerData.player_hp - damage_amount
	emit_signal("damage_taken")
	
	if right_knockback.is_colliding():
		knockback_force = -12000
		being_knockbacked = true
		
		animated = true
		animated_sprite.play("player_hit")
		
		await get_tree().create_timer(0.2).timeout
		being_knockbacked = false
		animated = false
	
	elif left_knockback.is_colliding():
		knockback_force = 12000
		being_knockbacked = true
		
		animated = true
		animated_sprite.play("player_hit")
		
		await get_tree().create_timer(0.2).timeout
		being_knockbacked = false
		animated = false
	
	if PlayerData.player_hp <= 0:
		die()

#Player dies, can no longer move, restart screen displays
func die():
	animated = true
	dead = true
	animated_sprite.play("die")
	
	emit_signal("player_dead")

func knockback(force):
	velocity.x = 0 
	velocity.x += force
	
	move_and_slide()
