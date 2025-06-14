extends Node2D

@export var cardScene : PackedScene = preload("res://card.tscn")
@export var DropAreaScene : PackedScene = preload("res://drop_area.tscn")

@onready var label = $Label

const additionalText : String = "Card1 is of TypeA, Card2 TypeB
DS0 accept any type
DS1 only TypeA
DS2 only TypeC (so nothing here)"

var cardInstance : Array = []
var dropareaInstance : Array = []

var get_back : bool = false


func _ready() -> void:
	var onlyCardsType : Array = [0, Card.TYPE.TYPEA, Card.TYPE.TYPEC]
	
	cardInstance.resize(2)
	for cidx in range(0, 2):
		cardInstance[cidx] = cardScene.instantiate()
		cardInstance[cidx].global_position = Vector2(randi_range(100,1000), randi_range(100,500))
		cardInstance[cidx].cid = cidx + 1
		add_child(cardInstance[cidx])
	
	cardInstance[0].Type = Card.TYPE.TYPEA
	cardInstance[1].Type = Card.TYPE.TYPEB
	
	dropareaInstance.resize(3)
	var base_spot_location =  Vector2((get_viewport().size.x / 3) + 150, get_viewport().size.y / 2)
	for didx in range(0, 3):
		dropareaInstance[didx] = DropAreaScene.instantiate()
		dropareaInstance[didx].global_position = base_spot_location + (Vector2(dropareaInstance[didx].get_size().x, 0) + Vector2(20, 0)) * didx 
		dropareaInstance[didx].did = didx
		dropareaInstance[didx].keepObject = true
		dropareaInstance[didx].CardTypesAllowed = onlyCardsType[didx]
		for cidx in range(0, 2):
			var connect_error = cardInstance[cidx].connect("card_is_dropped", dropareaInstance[didx]._on_card_is_dropped_received)
			#print("[d="+str(didx)+"]/[c="+str(cidx)+"] connect error ? "+str(connect_error))
	
		add_child(dropareaInstance[didx])


func _process(_delta: float) -> void:
	$Label.text = "Item "+str(cardInstance[0].cid)+" is on DropSpot "+str(cardInstance[0].did)+"\nItem "+str(cardInstance[1].cid)+" is on DropSpot "+str(cardInstance[1].did) + "\n" + additionalText


func _on_button_pressed() -> void:
	get_back = true
