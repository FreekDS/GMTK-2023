class_name Sheep
extends CharacterBody2D


enum LOOK {
	topLeft,
	topRight,
	botLeft,
	botRight
}

var canDash = false
var isDashing = false
var capturedHuman = null


var looksAt : LOOK = LOOK.botLeft

@export var speed = 300
@export var dashSpeed = 600
@export var tiltAmount = 0
@export_range(1,2) var sheepNumber = 1
@export_range(10,500,10) var blaatRange = 80


@onready var sprites : AnimatedSprite2D = $Sheep
@onready var sound : AudioStreamPlayer = $AudioStreamPlayer
@onready var blaatAreaShape : CollisionShape2D = $BlaatArea/CollisionShape2D
@onready var blaatArea : Area2D = $BlaatArea
@onready var cooldownTimer : Timer = $AttackCooldown

@onready var blaatContainer = $Blaat
@onready var blaatTopLeft = $Blaat/topLeft
@onready var blaatTopRight = $Blaat/topRight
@onready var blaatBotLeft = $Blaat/botLeft
@onready var blaatBotRight = $Blaat/botright

@onready var hoedContainer = $CowboyHoed
@onready var hoedTopLeft = $CowboyHoed/topLeft
@onready var hoedTopRight = $CowboyHoed/topRight
@onready var hoedBotLeft = $CowboyHoed/botLeft
@onready var hoedBotRight = $CowboyHoed/botRight

var canAttack = true
var blaating = false

signal attacked


func getInput() -> Vector2:
	var input = Vector2.ZERO
	input.x = Input.get_axis("left_%d" % sheepNumber, "right_%d" % sheepNumber)
	input.y = Input.get_axis("up_%d" % sheepNumber, "down_%d" % sheepNumber)
	return input.normalized()


func updateAnim(input: Vector2):
	if input.x < 0:
		if input.y < 0:
			looksAt = LOOK.topLeft
			sprites.play("left_top")
		else:
			looksAt = LOOK.botLeft
			sprites.play("left_bot")
	else:
		if input.y < 0:
			looksAt = LOOK.topRight
			sprites.play("right_top")
		else:
			looksAt = LOOK.botRight
			sprites.play("right_bot")
	


func _physics_process(_delta):
	var input = getInput()
	if isDashing:
		velocity = input * dashSpeed
	else:
		velocity = input * speed
	
	if velocity.is_zero_approx():
		sprites.stop()
		sprites.rotation_degrees = 0
		for ch in hoedContainer.get_children():
			ch.stop()
	else:
		updateAnim(velocity)
		sprites.rotation_degrees = -tiltAmount
		var goesLeft = input.x >= 0
		
		for ch in hoedContainer.get_children():
			if not ch.is_playing:
				ch.play()
		
#		sprites.flip_h = goesLeft
		if goesLeft:
			sprites.rotation_degrees = tiltAmount
	
	move_and_slide()
	
	if blaating:
		selectBasedOnMove(blaatContainer, blaatTopLeft, blaatBotLeft, blaatTopRight, blaatBotRight)
	else:
		for ch in blaatContainer.get_children():
			ch.visible = false
			
	if canDash or isDashing or (capturedHuman != null):
		selectBasedOnMove(hoedContainer, hoedTopLeft, hoedBotLeft, hoedTopRight, hoedBotRight)
	else:
		for ch in hoedContainer.get_children():
			ch.visible = false
			
	if capturedHuman != null:
		capturedHuman.global_position = global_position
		capturedHuman.rotate(35)


func selectBasedOnMove(containerNode, tl, bl, tr, br):
	for ch in containerNode.get_children():
		ch.visible = false
		var show : AnimatedSprite2D = null
		match looksAt:
			LOOK.topLeft:
				show = tl
			LOOK.botLeft:
				show = bl
			LOOK.topRight:
				show = tr
			LOOK.botRight:
				show = br
		show.play()
		show.visible = true


func _input(event):
	if event.is_action_pressed("blaat"):
		blaatAttack()
	if event.is_action_pressed("dash"):
		if canDash:
			print("DASH")
			canDash = false
			isDashing = true
			get_tree().create_timer(.3).timeout.connect(
				func():
					isDashing = false
			)
			


func blaatAttack():
	if not canAttack:
		return
	
	blaating = true
	
	get_tree().create_timer(.7).timeout.connect(
		func():
			blaating = false
	)
	
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


func enableDash():
	$Powerup.play()
	canDash = true


func _on_pickup_area_body_entered(body):
	if body is Human and isDashing:
		if body.state == Human.State.CAPTURED:
			return
		capturedHuman = body
		capturedHuman.sweat.visible = true
		body.detachFromSheepBack.connect(
			func():
				capturedHuman = null,
			CONNECT_ONE_SHOT
		)
