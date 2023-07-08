class_name Level
extends Node2D


signal levelLoaded(numberOfHumans: int)
signal humanCaptured
signal humanEscaped


func _ready():
	var humans = $Humans.get_child_count()
	assert(humans > 0, "Voegt nekeer humans toe lol")
	
	var levelLoad= func():
		levelLoaded.emit(humans)
	
	levelLoad.call_deferred()


func _on_capture_area_human_captured():
	humanCaptured.emit()


func _on_capture_area_human_escaped():
	humanEscaped.emit()
