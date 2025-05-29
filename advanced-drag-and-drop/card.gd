extends Node2D
class_name Card

@export var cid : int = -1
var did : int = -1

var mouseInsideCardArea : bool = false
#var is_dragged : bool = false

#signal dragged
#signal dropped
var dragged : bool = false
var dropped : bool = true
var locked : bool = false


signal card_is_dropped(ref : Node2D, coordinates : Vector2)

#https://forum.godotengine.org/t/solved-with-solution-how-to-click-only-the-top-area2d/13319/3
#https://forum.godotengine.org/t/how-to-have-collisionobject2d-input-event-only-trigger-for-the-topmost-collision-object/27334/2


func _ready() -> void:
	$Area2D.collision_layer = cid	#doesn't help for input


func _process(_delta: float) -> void:
	#if mouseInsideCardArea == true:
		#print("Card MC="+str(get_viewport().get_mouse_position()))
		#print("Dragged="+str(dragged)+"  Dropped="+str(dropped))
	if dragged == true:
		global_position = get_viewport().get_mouse_position()


func _input(event: InputEvent) -> void:
	print("Card["+str(cid)+"]: event="+str(event))
	#if Input.is_action_pressed("PickItem"):
		#print("pickitem action pressed")
		###get_viewport().set_input_as_handled() too strong, prevent all other nodes to get input
		#if dragged == false and dropped == true:
			#if locked == false:
				#if mouseInsideCardArea == true:
					#global_position = get_viewport().get_mouse_position()
					#scale_up()
					#dragged = true
					#dropped = false
#
	#if Input.is_action_just_released("PickItem"):
		#print("pickitem action released")
		#if dragged == true:
			#dropped = true
			#scale_down()
			#dragged = false
			#card_is_dropped.emit(self, global_position)


func _unhandled_input(event: InputEvent) -> void:
	if mouseInsideCardArea == true:
		print("card_ui["+str(cid)+"]: mica=true")
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed == true:
				print("card_ui["+str(cid)+"]: left mb pressed, define event as handled")
				get_viewport().set_input_as_handled()
				print("card_ui["+str(cid)+"]: here should be more code to move card")
				if dragged == false and dropped == true:
					if locked == false:
					#if mouseInsideCardArea == true:
						global_position = get_viewport().get_mouse_position()
						scale_up()
						dragged = true
						dropped = false
			else:
				#one issue remain: card stay dragged when MB released and card is under another one
				print("card_ui["+str(cid)+"]: left mb released")
				##removed get_viewport().set_input_as_handled()
				if dragged == true:
					dropped = true
					scale_down()
					dragged = false
					card_is_dropped.emit(self, global_position)


func is_mouse_inside() -> bool:
	return mouseInsideCardArea


func _on_area_2d_mouse_entered() -> void:
	print("Card["+str(cid)+"] MC="+str(get_viewport().get_mouse_position()))
	mouseInsideCardArea = true


func _on_area_2d_mouse_exited() -> void:
	mouseInsideCardArea = false


# ~ scaleup ? movecard ? moving ?
func scale_up() -> void:
	print("card["+str(cid)+"] is scaled up")
	scale *= 1.10
	#change ordering ~active card must be in front of all others
	
# scaleback ?
func scale_down() -> void:
	print("card["+str(cid)+"] is scaled down")
	scale *= 0.90
	##card_is_dropped.emit(self, global_position)
