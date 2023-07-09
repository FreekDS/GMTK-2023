class_name GameUI
extends CanvasLayer

signal timeUp
signal won

signal next
signal retry

@export var humanCount = 5
@export var label : RichTextLabel

@onready var gameTimer : Timer = $GameTime
@onready var levelSuccess = $"GameUI/Level Success popup"
@onready var levelFail = $GameUI/LevelFailedPop
@onready var timerLabel : RichTextLabel = $GameUI/TimerContainer/Panel/CenterContainer/HBoxContainer/RichTextLabel

@export
var currentCount = 0 : 
	set(c):
		currentCount = clamp(c, 0, humanCount)
		if label:
			label.text = "%d / %d" % [currentCount, humanCount]


func resetTimer(count = 120):
	gameTimer.start(count)

func _ready():
	resetTimer()
	currentCount = 0
	

func _on_human_captured():
	currentCount += 1
	if currentCount >= humanCount:
		get_tree().paused = true
		levelSuccess.visible = true


func _on_human_released():
	currentCount -= 1


func _on_game_time_timeout():
	get_tree().paused = true
	levelFail.visible = true


func _physics_process(delta):
	var remaining : int = int(gameTimer.time_left)
	if remaining >= 0:
		var minutes = int(remaining / 60)
		var seconds = int(remaining - (minutes * 60))
		timerLabel.text = "%02d : %02d" % [minutes, seconds]



func setLevel(level: int):
	levelSuccess.setLevel(int(level))


func _on_level_failed_pop_retry():
	retry.emit()
	levelFail.visible = false


func _on_level_success_popup_next():
	next.emit()
	levelSuccess.visible = false
