extends Node2D

var currentLevel = 0

@export var levels : Array[PackedScene] = []

var levelScene : Level = null

@onready var gameUi: GameUI = $GameUI


func _on_level_base_level_loaded(numberOfHumans):
	gameUi.humanCount = numberOfHumans
	gameUi.currentCount = 0


func restartCurrent():
	get_tree().paused = true
	gameUi.setLevel(int(currentLevel))
	FadeTransition.done.connect(
		func(_opened):
			get_tree().paused = false,
		CONNECT_ONE_SHOT
	)
	
	if levelScene != null:
		levelScene.queue_free()
	
	levelScene = levels[currentLevel].instantiate() as Level
	levelScene.name = "Level%d" % currentLevel
	levelScene.humanCaptured.connect(
		gameUi._on_human_captured
	)
	levelScene.humanEscaped.connect(
		gameUi._on_human_released
	)
	
	levelScene.levelLoaded.connect(
		_on_level_base_level_loaded
	)
	
	gameUi.resetTimer(levelScene.levelTime)
	FadeTransition.open.call_deferred()
	
	var addC = func():
		add_child(levelScene)
	addC.call_deferred()


func nextLevel():
	get_tree().paused = true
	currentLevel += 1
	if currentLevel >= len(levels):
		$EndCanvas.visible = true
		if levelScene != null:
			levelScene.queue_free.call_deferred()
		get_tree().paused = false
	else:
		# todo close transition first?
		FadeTransition.done.connect(
			func(_v):
				if levelScene != null:
					levelScene.queue_free.call_deferred()
				restartCurrent(),
			CONNECT_ONE_SHOT
		)
		FadeTransition.close()


func _input(event):
	if event is InputEventKey:
		if event.pressed and $EndCanvas.visible:
			FadeTransition.open()
			FadeTransition.done.connect(
				func(isOpen: bool):
					var menu = load("res://UI/MainMenu.tscn")
					get_tree().change_scene_to_packed(menu)
			)


func _ready():
	restartCurrent()


func _on_game_ui_time_up():
	restartCurrent()


func _on_game_ui_won():
	nextLevel()
