extends Node2D
class_name Card

@export var cid : int = -1
var locked : bool = false


var mouseInsideCardArea : bool = false
var is_dragged : bool = false

signal card_is_dropped(ref : Node2D, coordinates : Vector2)


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func is_mouse_inside() -> bool:
	return mouseInsideCardArea


func _on_area_2d_mouse_entered() -> void:
	mouseInsideCardArea = true


func _on_area_2d_mouse_exited() -> void:
	mouseInsideCardArea = false


func drag() -> void:
	print("card is dragged")
	scale *= 1.10
	
	
func drop() -> void:
	print("card is dropped")
	scale *= 0.90
	card_is_dropped.emit(self, global_position)
