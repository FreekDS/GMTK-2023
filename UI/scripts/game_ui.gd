extends CanvasLayer


@export var humanCount = 5
@export var label : RichTextLabel

var currentCount = 0 : 
	set(c):
		currentCount = clamp(c, 0, humanCount)
		if label:
			label.text = "%d / %d" % [currentCount, humanCount]
		if currentCount >= humanCount:
			$Victory.visible = true


func _ready():
	currentCount = 0
	

func _on_human_captured():
	currentCount += 1


func _on_human_released():
	currentCount -= 1
