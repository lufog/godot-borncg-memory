extends Control


@onready var tree := get_tree()
@onready var title_texture: TextureRect = %TitleTexture
@onready var title_label: Label = %TitleLabel
@onready var play_button: Button = %PlayButton


func _ready() -> void:
	tree.paused = true
	play_button.pressed.connect(self._new_game)


func _new_game() -> void:
	tree.paused = false
	GameManager.reset_game()
	queue_free()


func win(goal: int, seconds: int, moves: int) -> void:
	title_texture.texture = load("res://ui/assets/textures/complete.png")
	title_label.text = "You found %d pairs in %d seconds, and flipped %d pairs of cards!" % [goal, seconds, moves]
