extends Control

signal next


@onready var levelText = $CenterContainer/Panel/CenterContainer/VBoxContainer/RichTextLabel


func setLevel(l: int):
	if l+1 == 5:
		$CenterContainer/Panel/CenterContainer/VBoxContainer/HBoxContainer/Next.text = "End game"
	levelText.text = "[center]Completed level %d/5 \n\n" % (l+1)


func _on_next_pressed():
	next.emit()


func _on_menu_pressed():
	var menu = load("res://UI/MainMenu.tscn")
	FadeTransition.done.connect(
		func(isOpen: bool):
			if not isOpen:
				get_tree().change_scene_to_packed(menu)
	)
	FadeTransition.close()
