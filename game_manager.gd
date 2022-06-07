extends Node


var score := 0
var card_back: Resource = preload("res://assets/cards/cardBack_red2.png")
var deck: Array[Card] = Array()
var card_first: Card
var card_second: Card
var match_timer := Timer.new()
var flip_timer := Timer.new()

@onready var game = $/root/Game as Game


func _ready() -> void:
	_fill_deck()
	_deal_deck()
	_setup_timers()


func choose_card(card: Card) -> void:
	if card_first == null:
		card_first = card
		card_first.flip()
		card_first.disabled = true
	elif card_second == null:
		card_second = card
		card_second.flip()
		card_second.disabled = true
		_check_cards()
	else:
		pass


func _setup_timers() -> void:
	match_timer.timeout.connect(self._match_cards_and_score)
	match_timer.one_shot = true
	add_child(match_timer)
	
	flip_timer.timeout.connect(self._turn_over_cards)
	flip_timer.one_shot = true
	add_child(flip_timer)


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
	await game.ready
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
	print(score)
	card_first.modulate = Color(0.6, 0.6, 0.6, 0.5)
	card_second.modulate = Color(0.6, 0.6, 0.6, 0.5)
	card_first = null
	card_second = null
