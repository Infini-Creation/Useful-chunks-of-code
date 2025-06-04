extends Node2D
class_name Card

enum TYPE { TYPEA = 1, TYPEB = 2, TYPEC = 4 }

@export var cid : int = -1
var did : int = -1

var mouseInsideCardArea : bool = false

var dragged : bool = false
var dropped : bool = true
var locked : bool = false
var Type : int = 0

signal card_is_dropped(ref : Node2D, coordinates : Vector2)

#https://forum.godotengine.org/t/solved-with-solution-how-to-click-only-the-top-area2d/13319/3
#https://forum.godotengine.org/t/how-to-have-collisionobject2d-input-event-only-trigger-for-the-topmost-collision-object/27334/2


func _process(_delta: float) -> void:

	if dragged == true:
		global_position = get_viewport().get_mouse_position()


func _unhandled_input(event: InputEvent) -> void:
	if mouseInsideCardArea == true:
		#print("card_ui["+str(cid)+"]: mica=true")
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed == true:
				#print("card_ui["+str(cid)+"]: left mb pressed, define event as handled")
				get_viewport().set_input_as_handled()
				#print("card_ui["+str(cid)+"]: here should be more code to move card")
				if dragged == false and dropped == true:
					if locked == false:
					#if mouseInsideCardArea == true:
						global_position = get_viewport().get_mouse_position()
						scale_up()
						z_index = 5
						dragged = true
						dropped = false
			else:
				#print("card_ui["+str(cid)+"]: left mb released")
				if dragged == true:
					dropped = true
					scale_down()
					z_index = 0
					dragged = false
					card_is_dropped.emit(self, global_position)


func is_mouse_inside() -> bool:
	return mouseInsideCardArea


func _on_area_2d_mouse_entered() -> void:
	#print("Card["+str(cid)+"] MC="+str(get_viewport().get_mouse_position()))
	mouseInsideCardArea = true


func _on_area_2d_mouse_exited() -> void:
	mouseInsideCardArea = false

#1.6 /1.25      0.625 /0.8
func scale_up() -> void:
	#print("card["+str(cid)+"] is scaled up")
	scale *= 1.25
	#change ordering ~active card must be in front of all others

#issue: resizes are not complementary !!
func scale_down() -> void:
	#print("card["+str(cid)+"] is scaled down")
	scale *= 0.8
