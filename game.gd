extends Node2D


@onready var level : Level = $LevelBase
@onready var gameUi: GameUI = $GameUI

func _on_level_base_level_loaded(numberOfHumans):
	gameUi.humanCount = numberOfHumans
	gameUi.currentCount = 0

func _ready():
	get_tree().paused = true
	FadeTransition.done.connect(
		func(_opened):
			get_tree().paused = false,
		CONNECT_ONE_SHOT
	)
	FadeTransition.open.call_deferred()
