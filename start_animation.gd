extends Node2D

const game = preload("res://game.tscn")


func _ready():
	FadeTransition.open()
	FadeTransition.done.connect(
		func(isOpen: bool):
			if not isOpen:
				get_tree().change_scene_to_packed(game)
			else:
				$AnimationPlayer.play("StartAnimation")
	)

func _on_animation_player_animation_finished(anim_name):
	FadeTransition.close()
