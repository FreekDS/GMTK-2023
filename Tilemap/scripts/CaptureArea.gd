extends Area2D

signal humanCaptured
signal humanEscaped




func _on_area_entered(area):
	pass # Replace with function body.


func _on_body_entered(body):
	if body is Human:
		body.changeState(Human.State.CAPTURED)
		humanCaptured.emit()
		print("menseke")
	else:
		print("schapeke")


func _on_body_exited(body):
	if body is Human:
		body.changeState(Human.State.FREE)
		humanEscaped.emit()
		print("menseke weg")
	else:
		print("schapeke")
