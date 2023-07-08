class_name Human
extends CharacterBody2D

enum State {CAPTURED, FREE, FLEEING}

const SPEED = 0
const SPEED_CAPTURED = 50

@onready var newTargetTimer = $NewTargetTimer
@export var drawRadius = false
@export var nextLocationRadius = 150

var walkForAtLeast = 2 # seconds
var fleeTime = 3

var target = Vector2.ZERO
var state : State = State.FREE
var stateBeforeFleeing : State = State.FREE

signal stateChanged(newState: State)

func _ready():
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


func _physics_process(delta):
	
	if target.distance_to(global_position) < 1:
		pickNewTarget()
	
	var direction = (target - global_position).normalized()
	
	if direction.x < -.35:
		rotation_degrees = -10
	elif direction.x > .35:
		rotation_degrees = 10
	else:
		rotation_degrees = 0
	
	if state == State.CAPTURED:
		velocity = direction * SPEED_CAPTURED
	elif state == State.FLEEING:
		velocity = direction * SPEED * 2
	else:
		velocity = direction * SPEED
	
	move_and_slide()
	var collision = get_last_slide_collision()
	if collision:
#		print("collision TODO check if is with wall")
# collsion masks zijn ingesteld
		target = global_position + collision.get_normal().normalized() * nextLocationRadius
		newTargetTimer.start(walkForAtLeast)


func changeState(newState: State):
	state = newState
	stateChanged.emit(newState)
	

func flee(from: Vector2):
	if state == State.CAPTURED:
		return
	print("weglopen")
	target = (global_position - from).normalized() * 100000
	if state != State.FLEEING:
		stateBeforeFleeing = state
	changeState(State.FLEEING)
	newTargetTimer.start(fleeTime)


func _on_new_target_timer_timeout():
	if state == State.FLEEING:
		print("Tis goed jom, kalmeert maar")
		changeState(stateBeforeFleeing)
	pickNewTarget()
	print("New target", target)
	newTargetTimer.start(walkForAtLeast)
