extends Node2D

@export var cardScene : PackedScene = preload("res://card.tscn")
@export var DropAreaScene : PackedScene = preload("res://drop_area.tscn")

var cardInstance : Array = []
var dropareaInstance : Array = []

var dragged : bool = false
var dropped : bool = true


func _ready() -> void:
	cardInstance.resize(2)
	for cidx in range(0, 2):
		cardInstance[cidx] = cardScene.instantiate()
		cardInstance[cidx].global_position = Vector2(randi_range(100,1000), randi_range(100,500))
		cardInstance[cidx].cid = cidx + 1
		add_child(cardInstance[cidx])
	
	dropareaInstance.resize(3)
	var base_spot_location =  Vector2((get_viewport().size.x / 3) + 150, get_viewport().size.y / 2)
	for didx in range(0, 3):
		dropareaInstance[didx] = DropAreaScene.instantiate()
		dropareaInstance[didx].global_position = base_spot_location + (Vector2(dropareaInstance[didx].get_size().x, 0) + Vector2(20, 0)) * didx 
		dropareaInstance[didx].did = didx
		dropareaInstance[didx].keepObject = true
		for cidx in range(0, 2):
			var connect_error = cardInstance[cidx].connect("card_is_dropped", dropareaInstance[didx]._on_card_is_dropped_received)
			print("[d="+str(didx)+"]/[c="+str(cidx)+"] connect error ? "+str(connect_error))
	
		add_child(dropareaInstance[didx])


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("PickItem"):

		if dragged == false and dropped == true:
			print("not dragged and dropped, take it")

		else:
			print("dragged and not yet dropped")

	if Input.is_action_just_released("PickItem"):
		if dragged == true:
			dropped = true

			dragged = false

		else:
			print("click released at "+str(get_viewport().get_mouse_position()))
