extends Camera2D

@export var player : Sheep

@onready var top = $top
@onready var bot = $bot
@onready var left = $left
@onready var right = $right


func _process(delta):
	var close = false
	for marker in [top, bot, left, right]:
		if marker.global_position.distance_to(player.global_position) < 100:
			offset = offset.move_toward(marker.global_position, 3)
			close = true
	if not close:
		offset = offset.move_toward(Vector2.ZERO, 3)
			
			
			
