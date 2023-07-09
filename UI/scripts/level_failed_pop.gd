extends Control


signal retry

func _on_menu_pressed():
	var menu = load("res://UI/MainMenu.tscn")
	FadeTransition.done.connect(
		func(isOpen: bool):
			if not isOpen:
				get_tree().change_scene_to_packed(menu)
	)
	FadeTransition.close()


func _on_retry_pressed():
	retry.emit()
