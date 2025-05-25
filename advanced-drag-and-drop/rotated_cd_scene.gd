extends Node2D

@export var cardScene : PackedScene = preload("res://card.tscn")
@export var DropAreaScene : PackedScene = preload("res://drop_area.tscn")
@export var SnapDistanceThreshold : float = 65.0

var cardInstance
var dropareaInstance

var dragged : bool = false
var dropped : bool = true

var lastCardPosition : Vector2i = Vector2i.ZERO
var debugProcessDelay : int = 0


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
	if Input.is_action_pressed("PickItem"):

		if dragged == false and dropped == true:
			if debugProcessDelay % 100 == 0:
				print("not dragged and dropped, take it")
				
			if cardInstance.is_mouse_inside() == true:
				if cardInstance.locked == false:
					# move all this to card
					cardInstance.global_position = get_viewport().get_mouse_position()
					#cardInstance.scale *= 1.10 #1.25
					cardInstance.drag()
					dragged = true
					dropped = false
					cardInstance.is_dragged = true

		else:
			if debugProcessDelay % 100 == 0:
				print("dragged and not yet dropped")

			cardInstance.global_position = get_viewport().get_mouse_position()

	if Input.is_action_just_released("PickItem"):
		if dragged == true:
			dropped = true
			#cardInstance.scale *= 0.9 #0.8
			cardInstance.drop()
			dragged = false
			lastCardPosition = get_viewport().get_mouse_position()
			print("dropped at "+str(lastCardPosition))


		else:
			print("click released at "+str(get_viewport().get_mouse_position()))
