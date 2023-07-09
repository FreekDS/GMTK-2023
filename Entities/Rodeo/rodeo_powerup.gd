extends Area2D




func _on_body_entered(body):
	if body is Sheep:
		if body.canDash == true or body.capturedHuman != null:
			return
		body.enableDash()
		queue_free.call_deferred()
