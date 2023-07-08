extends Control


const game = preload("res://game.tscn")


func _ready():
	FadeTransition.done.connect(
		func(isOpen: bool):
			if not isOpen:
				get_tree().change_scene_to_packed(game)
	)

func _on_play_pressed():
	FadeTransition.close()


func _on_credits_pressed():
	pass
