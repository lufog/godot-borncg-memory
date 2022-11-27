extends TextureButton


@onready var tree := get_tree()


func _pressed() -> void:
	tree.paused = !tree.paused
	
	if tree.paused:
		texture_normal = preload("res://ui/assets/textures/play.png")
	else:
		texture_normal = preload("res://ui/assets/textures/pause.png")
