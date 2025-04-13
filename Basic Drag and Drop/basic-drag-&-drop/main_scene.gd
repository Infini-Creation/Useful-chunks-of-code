extends Node2D

@export var dummyScene : PackedScene = preload("res://some_stuff.tscn")

@onready var debugText = $Label

var dummy : Node2D

var dragged : bool = false
var dropped : bool = true

var lastDummyPosition : Vector2i = Vector2i.ZERO
var debugProcessDelay : int = 0


func _ready() -> void:
	dummy = dummyScene.instantiate()
	add_child(dummy)
	dummy.global_position = get_viewport().size / 2.0


func _process(_delta: float) -> void:
	if dropped == true:
		debugProcessDelay += 1
		if debugProcessDelay % 100 == 0:
			print("dummy dropped")
			debugProcessDelay = 0
			
	debugText.text = "cursor: "+str(get_viewport().get_mouse_position())+"  dummy Position: "+str(dummy.global_position)+"  dropped: "+str(dropped)+" dragged: "+str(dragged)
	

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("PickItem"):

		if dragged == false and dropped == true:
			if debugProcessDelay % 100 == 0:
				print("not dragged and dropped, take it")
				
			if dummy.is_mouse_inside() == true:
				dummy.global_position = get_viewport().get_mouse_position()
				dummy.scale *= 1.6 #1.25
				dragged = true
				dropped = false

		else:
			if debugProcessDelay % 100 == 0:
				print("dragged and not yet dropped")

			dummy.global_position = get_viewport().get_mouse_position()

	if Input.is_action_just_released("PickItem"):
		if dragged == true:
			dropped = true
			dummy.scale *= 0.625 #0.8
			dragged = false
			lastDummyPosition = get_viewport().get_mouse_position()
			print("dropped at "+str(lastDummyPosition))


		else:
			print("click released at "+str(get_viewport().get_mouse_position()))
