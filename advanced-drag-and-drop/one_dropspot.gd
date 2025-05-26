extends Node2D

@export var cardScene : PackedScene = preload("res://card.tscn")
@export var DropAreaScene : PackedScene = preload("res://drop_area.tscn")

var cardInstance
var dropareaInstance

var dragged : bool = false
var dropped : bool = true

var lastCardPosition : Vector2i = Vector2i.ZERO
var debugProcessDelay : int = 0


func _ready() -> void:
	cardInstance = cardScene.instantiate()
	cardInstance.global_position = $cardSpot.global_position
	cardInstance.cid = 1
	add_child(cardInstance)
	
	dropareaInstance = DropAreaScene.instantiate()
	dropareaInstance.global_position = $dropareaSpot.global_position
	dropareaInstance.did = 1
	dropareaInstance.keepObject = true
	var connect_error = cardInstance.connect("card_is_dropped", dropareaInstance._on_card_is_dropped_received)
	print("connect error ? "+str(connect_error))
	
	add_child(dropareaInstance)


func _process(delta: float) -> void:
	pass


func _input(_event: InputEvent) -> void:
	pass
