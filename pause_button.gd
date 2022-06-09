extends TextureButton


@onready var tree := get_tree()


func _pressed() -> void:
	tree.paused = !tree.paused
	
	if tree.paused:
		texture_normal = preload("res://assets/ui/play.png")
	else:
		texture_normal = preload("res://assets/ui/pause.png")
