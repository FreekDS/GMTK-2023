class_name Human
extends CharacterBody2D

enum State {CAPTURED, FREE, FLEEING}

const SPEED = 100
const SPEED_CAPTURED = 50

@export var isRealHuman = false

@onready var newTargetTimer = $NewTargetTimer
@onready var sweat = $Sweat
@onready var sprites = $Dog
@onready var sounds = $SOUNDS

@export var drawRadius = false
@export var nextLocationRadius = 150

var walkForAtLeast = 2 # seconds
var fleeTime = 3

var target = Vector2.ZERO
var state : State = State.FREE
var stateBeforeFleeing : State = State.FREE


var isOnSheepBack = false

var barkTimer = Timer.new()

signal stateChanged(newState: State)
signal detachFromSheepBack

func _ready():
	var randPitch = randf_range(.9, 1.3)
	for sound in sounds.get_children():
		sound.pitch_scale = randPitch
	
	add_child(barkTimer)
	barkTimer.one_shot = true
	barkTimer.timeout.connect(
		func():
			if state != State.CAPTURED:
				sounds.get_children().pick_random().play()
			barkTimer.start(randf_range(2,5))
	)
	barkTimer.start(randf_range(1,3))
	
	pickNewTarget()
	newTargetTimer.start(walkForAtLeast)


func pickNewTarget():
	var newTarget = global_position
	var angle = randf_range(0, 2 * PI)
	newTarget.x += nextLocationRadius * sin(angle)
	newTarget.y += nextLocationRadius * cos(angle)
	target = newTarget
	

func _draw():
	if drawRadius:
		draw_arc(Vector2.ZERO, nextLocationRadius, 0, 360, 100, Color.RED)

func updateAnimations(input: Vector2):
	if input.x < 0:
		if input.y < 0:
			sprites.play("leftTop")
		else:
			sprites.play("leftBot")
	else:
		if input.y < 0:
			sprites.play("rightTop")
		else:
			sprites.play("rightBot")


func _physics_process(_delta):
	if isOnSheepBack:
		return

	if target.distance_to(global_position) < 1:
		pickNewTarget()
	
	var direction = (target - global_position).normalized()
	
	if direction.x < -.35:
		rotation_degrees = -10
	elif direction.x > .35:
		rotation_degrees = 10
	else:
		rotation_degrees = 0
	
	var speed = SPEED
	if state == State.CAPTURED:
		sweat.visible = false
		speed = SPEED_CAPTURED
		sprites.speed_scale = .9
	elif state == State.FLEEING:
		speed = SPEED * 2
		sprites.speed_scale = 1.2
	else:
		sprites.speed_scale = 1
	
	updateAnimations(direction)
	
	velocity = direction * speed
	move_and_slide()
	var collision = get_last_slide_collision()
	if collision:
#		print("collision TODO check if is with wall")
# collsion masks zijn ingesteld
		target = global_position + collision.get_normal().normalized() * nextLocationRadius
		if state != State.FLEEING:
			newTargetTimer.start(walkForAtLeast)


func changeState(newState: State):
	if newState == State.CAPTURED:
		isOnSheepBack = false
		rotation_degrees = 0
		detachFromSheepBack.emit()
	state = newState
	stateChanged.emit(newState)
	

func flee(from: Vector2):
	if state == State.CAPTURED:
		newTargetTimer.start(fleeTime)
		target = (global_position - from).normalized() * 100000
		return

	sweat.visible = true
	target = (global_position - from).normalized() * 100000
	if state != State.FLEEING:
		stateBeforeFleeing = state
	changeState(State.FLEEING)
	newTargetTimer.start(fleeTime)


func _on_new_target_timer_timeout():
	if state == State.FLEEING:
		sweat.visible = false
		changeState(stateBeforeFleeing)
	pickNewTarget()
	newTargetTimer.start(walkForAtLeast)
