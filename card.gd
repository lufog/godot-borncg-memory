extends TextureButton
class_name Card

var suit: int
var value: int
var face: Texture2D
var back: Texture2D


func _init(s: int, v: int) -> void:
	value = v
	suit = s
	face = load("res://assets/cards/card-"+str(suit)+"-"+str(value)+".png")
	back = GameManager.card_back
	texture_normal = back


func _ready() -> void:
	size_flags_horizontal = 3
	size_flags_vertical = 3
	ignore_texture_size = true
	stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED


func _pressed() -> void:
	GameManager.choose_card(self)


func flip() -> void:
	if texture_normal == back:
		texture_normal = face
	else:
		texture_normal = back
