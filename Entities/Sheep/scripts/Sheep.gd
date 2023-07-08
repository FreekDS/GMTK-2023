class_name Sheep
extends CharacterBody2D

@export var speed = 300
@export var tiltAmount = 10
@export_range(1,2) var sheepNumber = 1
@export_range(10,500,10) var blaatRange = 80

@onready var animations : AnimationPlayer = $Animations
@onready var sprites : AnimatedSprite2D = $Sheep
@onready var sound : AudioStreamPlayer = $AudioStreamPlayer
@onready var blaatAreaShape : CollisionShape2D = $BlaatArea/CollisionShape2D
@onready var blaatArea : Area2D = $BlaatArea
@onready var cooldownTimer : Timer = $AttackCooldown

var canAttack = true

signal attacked


func getInput() -> Vector2:
	var input = Vector2.ZERO
	input.x = Input.get_axis("left_%d" % sheepNumber, "right_%d" % sheepNumber)
	input.y = Input.get_axis("up_%d" % sheepNumber, "down_%d" % sheepNumber)
	return input.normalized()


func updateAnim(input: Vector2):
	if input.x < 0:
		if input.y < 0:
			sprites.play("left_top")
		else:
			sprites.play("left_bot")
	else:
		if input.y < 0:
			sprites.play("right_top")
		else:
			sprites.play("right_bot")
	


func _physics_process(_delta):
	var input = getInput()
	velocity = input * speed
	
	if velocity.is_zero_approx():
		sprites.stop()
		sprites.rotation_degrees = 0
	else:
		updateAnim(velocity)
		sprites.rotation_degrees = -tiltAmount
		var goesLeft = input.x >= 0
		
#		sprites.flip_h = goesLeft
		if goesLeft:
			sprites.rotation_degrees = tiltAmount
	
	move_and_slide()


func _input(event):
	if event.is_action_pressed("blaat"):
		blaatAttack()


func blaatAttack():
	if not canAttack:
		return
	cooldownTimer.start()
	sound.pitch_scale = randf_range(1,2)
	sound.play()
	canAttack = false
	for body in blaatArea.get_overlapping_bodies():
		if body is Human:
			body.flee(global_position)
	attacked.emit()


func _on_attack_cooldown_timeout():
	canAttack = true
