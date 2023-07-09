extends Control


const game = preload("res://start_animation.tscn")


func _ready():
	get_tree().paused = false
	if FadeTransition.closed:
		FadeTransition.open()
	FadeTransition.done.connect(
		func(isOpen: bool):
			if !isOpen:
				get_tree().change_scene_to_packed(game)
	)

func _on_play_pressed():
	FadeTransition.close()


func _on_credits_pressed():
	pass
