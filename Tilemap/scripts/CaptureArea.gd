extends Area2D

signal humanCaptured
signal humanEscaped


func _on_body_entered(body):
	if body is Human:
		body.changeState(Human.State.CAPTURED)
		humanCaptured.emit()
#		print("menseke")


func _on_body_exited(body):
	if body is Human:
		body.changeState(Human.State.FREE)
		humanEscaped.emit()
