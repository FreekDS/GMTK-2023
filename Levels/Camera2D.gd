extends Camera2D

@export var player : Sheep

@onready var top = $top
@onready var bot = $bot
@onready var left = $left
@onready var right = $right


func markerToVec(m) -> Vector2:
	return m.global_position


func fixTop(px, py):
	var pos = markerToVec(top)
	if py < pos.y:
		print("TOP")
		offset = offset.move_toward(pos, 4)
		return true
	return false
	
func fixBot(px, py) -> bool:
	var pos = markerToVec(bot)
	if py > pos.y:
		offset = offset.move_toward(pos, 4)
		return true
	return false


func fixRight(px, py):
	var pos = markerToVec(right)
	if px > pos.x:
		offset = offset.move_toward(pos, 4)
		return true
	return false
	
func fixLeft(px, py):
	var pos = markerToVec(left)
	if px < pos.x:
		print("ff")
		offset = offset.move_toward(pos, 4)
		return true
	return false

func _process(delta):
	var close = false
	
	var px = player.global_position.x
	var py = player.global_position.y
	
	if fixTop(px, py) or fixBot(px, py) or fixLeft(px, py) or fixRight(px, py):
		pass
	else:
		offset = offset.move_toward(Vector2.ZERO, 4)
	
			
			
			
