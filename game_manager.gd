extends Node


var card_back: Resource = preload("res://assets/cards/cardBack_red2.png")
var deck: Array[Card] = Array()
var card_first: Card
var card_second: Card
var match_timer := Timer.new()
var flip_timer := Timer.new()
var seconds_timer := Timer.new()

var score := 0
var seconds := 0
var moves := 0
var goal := 26

var score_label: Label
var seconds_label: Label
var moves_label: Label
var reset_button: TextureButton

var pop_up: PackedScene = load("res://pop_up.tscn")

@onready var tree := get_tree()
@onready var game := $/root/Game as Game


func _ready() -> void:
	await game.ready
	
	_fill_deck()
	_deal_deck()
	_setup_timers()
	_setup_hud()
	
	var splash = pop_up.instantiate()
	game.add_child(splash)


func choose_card(card: Card) -> void:
	if card_first == null:
		card_first = card
		card_first.flip()
		card_first.disabled = true
	elif card_second == null:
		card_second = card
		card_second.flip()
		card_second.disabled = true
		moves += 1
		moves_label.text = str(moves)
		_check_cards()
	else:
		pass


func reset_game() -> void:
	tree.paused = false
	
	for i in deck.size():
		deck[i].queue_free()
	
	deck.clear()
	score = 0
	score_label.text = "0"
	seconds = 0
	seconds_label.text = "0"
	moves = 0
	moves_label.text = "0"
	
	_fill_deck()
	_deal_deck()


func _setup_timers() -> void:
	match_timer.timeout.connect(self._match_cards_and_score)
	match_timer.one_shot = true
	add_child(match_timer)
	
	flip_timer.timeout.connect(self._turn_over_cards)
	flip_timer.one_shot = true
	add_child(flip_timer)
	
	seconds_timer.timeout.connect(self._count_seconds)
	seconds_timer.autostart = true
	add_child(seconds_timer)


func _setup_hud() -> void:
	score_label = game.hud.get_node("Panel/Sections/ScoreSection/Value")
	score_label.text = str(score)
	
	seconds_label = game.hud.get_node("Panel/Sections/TimerSection/Value")
	seconds_label.text = str(seconds)
	
	moves_label = game.hud.get_node("Panel/Sections/MovesSection/Value")
	moves_label.text = str(moves)
	
	reset_button = game.hud.get_node("Panel/Sections/ButtonsSection/ResetButton")
	reset_button.pressed.connect(self.reset_game)


func _check_cards() -> void:
	if card_first.value == card_second.value:
		match_timer.start(0.5)
	else:
		flip_timer.start(1)


func _fill_deck() -> void:
	for s in range(1, 5):
		for v in range(1, 14):
			deck.append(Card.new(s, v))
			v += 1


func _deal_deck() -> void:
	deck.shuffle()
	for i in deck.size():
		game.card_container.add_child(deck[i])


func _turn_over_cards() -> void:
	card_first.flip()
	card_first.disabled = false
	card_second.flip()
	card_second.disabled = false
	card_first = null
	card_second = null


func _match_cards_and_score() -> void:
	score += 1
	score_label.text = str(score)
	card_first.modulate = Color(0.6, 0.6, 0.6, 0.5)
	card_second.modulate = Color(0.6, 0.6, 0.6, 0.5)
	card_first = null
	card_second = null
	
	if score == goal:
		var win_screen := pop_up.instantiate()
		game.add_child(win_screen)
		win_screen.win(goal, seconds, moves)

func _count_seconds() -> void:
	seconds += 1
	seconds_label.text = str(seconds)
