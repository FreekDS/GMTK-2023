extends CanvasLayer

@onready var cloudRect = $ColorRect
@onready var cloudtexture = $TextureRect

var frontSpeed = 10

var pixelOffset = 0


func _on_timer_timeout():
	return
	pixelOffset += 4
	var n = cloudRect.material.get_shader_parameter("noise_texture")
	n.noise.offset.x += 4
	cloudRect.material.set_shader_parameter("noise_texture", n)
