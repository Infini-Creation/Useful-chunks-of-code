extends Node2D

@export var cardScene : PackedScene = preload("res://card.tscn")
@export var DropAreaScene : PackedScene = preload("res://drop_area.tscn")

var cardInstance
var dropareaInstance

var get_back : bool = false

func _ready() -> void:
	cardInstance = cardScene.instantiate()
	cardInstance.global_position = $cardSpot.global_position
	cardInstance.cid = 2
	add_child(cardInstance)
	
	dropareaInstance = DropAreaScene.instantiate()
	dropareaInstance.global_position = $dropareaSpot.global_position
	dropareaInstance.did = 2
	dropareaInstance.keepObject = false
	dropareaInstance.rotAngle = 90.0
	var connect_error = cardInstance.connect("card_is_dropped", dropareaInstance._on_card_is_dropped_received)
	print("connect error ? "+str(connect_error))
	
	add_child(dropareaInstance)


func _input(_event: InputEvent) -> void:
	pass


func _on_button_pressed() -> void:
	get_back = true
