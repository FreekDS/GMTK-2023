class_name Level
extends Node2D

signal levelLoaded(numberOfHumans: int)

func _ready():
	var humans = $Humans.get_child_count()
	assert(humans > 0, "Voegt nekeer humans toe lol")
	levelLoaded.emit(humans)
