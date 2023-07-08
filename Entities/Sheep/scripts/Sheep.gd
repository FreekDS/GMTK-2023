class_name Sheep
extends CharacterBody2D

@export var speed = 300
@export var tiltAmount = 10
@export_range(1,2) var sheepNumber = 1
@export_range(10,500,10) var blaatRange = 80

@onready var animations : AnimationPlayer = $Animations
@onready var sprite : Sprite2D = $Sheep
@onready var sound : AudioStreamPlayer = $AudioStreamPlayer
@onready var blaatAreaShape : CollisionShape2D = $BlaatArea/CollisionShape2D
@onready var blaatArea : Area2D = $BlaatArea


signal attacked


func getInput() -> Vector2:
	var input = Vector2.ZERO
	input.x = Input.get_axis("left_%d" % sheepNumber, "right_%d" % sheepNumber)
	input.y = Input.get_axis("up_%d" % sheepNumber, "down_%d" % sheepNumber)
	return input.normalized()


func _physics_process(_delta):
	var input = getInput()
	velocity = input * speed
	
	if velocity.is_zero_approx():
		animations.stop()
		sprite.rotation_degrees = 0
	else:
		animations.play("walk")
		sprite.rotation_degrees = tiltAmount
		var goesLeft = input.x < 0
		
		sprite.flip_h = goesLeft
		if goesLeft:
			sprite.rotation_degrees = -tiltAmount
	
	move_and_slide()
	
	#queue_redraw()


func _input(event):
	if event.is_action_pressed("blaat"):
		sound.pitch_scale = randf_range(1,2)
		sound.play()
		blaatAttack()
		


#func _draw():
#	draw_arc(position, blaatRange, 0, 360, 100, Color.RED)


func blaatAttack():
	for body in blaatArea.get_overlapping_bodies():
		if body is Human:
			body.flee(global_position)
	attacked.emit()

	
