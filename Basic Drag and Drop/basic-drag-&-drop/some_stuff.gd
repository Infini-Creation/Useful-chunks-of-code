extends Node2D


var Size : Vector2 = Vector2.ZERO
var mouseInsideCardArea : bool = false

@onready var ssarea : Area2D = $Area2D
@onready var textrect : TextureRect = $TextureRect


func is_mouse_inside() -> bool:
	return mouseInsideCardArea


#func _on_texture_rect_mouse_entered() -> void:
	#print("ss: mouse is in the area")
	#mouseInsideCardArea = true
#
#
#func _on_texture_rect_mouse_exited() -> void:
	#print("ss: mouse is not in the area")
	#mouseInsideCardArea = false


func _on_area_2d_mouse_entered() -> void:
	print("ssa: mouse is in the area")
	mouseInsideCardArea = true


func _on_area_2d_mouse_exited() -> void:
	print("ssa: mouse is not in the area")
	mouseInsideCardArea = false
