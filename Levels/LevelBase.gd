class_name Level
extends Node2D


var rodeoPowerup = preload("res://Entities/Rodeo/rodeo_powerup.tscn")

@export var levelTime = 120

signal levelLoaded(numberOfHumans: int)
signal humanCaptured
signal humanEscaped


func _ready():
	$Timer.start(10)
	var humans = $Humans.get_child_count()
	assert(humans > 0, "Voegt nekeer humans toe lol")
	
	var levelLoad= func():
		levelLoaded.emit(humans)
	
	levelLoad.call_deferred()
	spawnPowerUp.call_deferred()


func _on_capture_area_human_captured():
	humanCaptured.emit()


func _on_capture_area_human_escaped():
	humanEscaped.emit()


func spawnPowerUp():
	if $Powerups.get_child_count() > 1:
		return
	
	print("Spawn")
	
	var tm = $TileMap as TileMap
	var cell = tm.get_used_cells(0).pick_random()
	var localPosition = tm.map_to_local(cell)
	
	var rodeo = rodeoPowerup.instantiate()
	rodeo.name = "RodeoPowerup"
	$Powerups.add_child(rodeo)
	rodeo.global_position = tm.to_global(localPosition)


func _on_timer_timeout():
	spawnPowerUp()
	$Timer.start(10)
