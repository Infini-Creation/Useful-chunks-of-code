extends Node2D

@onready var area1 : Area2D = $Area2D_1
@onready var area2 : Area2D = $Area2D_2
@onready var debugLabel : Label = $Label


var data_showed : bool = false
var debug_intersect : Rect2

var rect_alpha : float = 1.0
var time : float = 0.0

var intersect_percentage : float = 0.0
var drop_area_surface : float = 0.0
var moving_area_surface : float = 0.0


func _ready() -> void:
	print("_ready called")


func _process(_delta: float) -> void:
	time += _delta

	queue_redraw()
	
	if data_showed == false:
		print("AREA1 obj="+str(area1)+" cs1="+str($Area2D_1/CollisionShape2D))
		print("AREA2 obj="+str(area2)+" cs2="+str($Area2D_2/CollisionShape2D))
		
		var ovareas1 = area1.get_overlapping_areas()
		var ovareas2 = area2.get_overlapping_areas()
		print("ovlap area 1="+str(ovareas1))
		print("ovlap area 2="+str(ovareas2))
		data_showed = true
	else:
		pass

	intersect_percentage = debug_intersect.get_area() / drop_area_surface * 100.0
	debugLabel.text = "Intersect %=" + str(intersect_percentage)

func _draw() -> void:
	#print("ra="+str(rect_alpha) + "  di="+str(debug_intersect))
	
	if debug_intersect != null:
		draw_rect(debug_intersect, Color(1.0, 1.0, 1.0, rect_alpha))
		rect_alpha = abs(sin(time))

		#draw_rect(Rect2(Vector2(10,10), Vector2(100,100)), Color(1.0, 1.0, 1.0, rect_alpha))


func _on_area_2d_1_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("Area1: shape ent sig: area="+str(area))
	var other_shape_owner = area.shape_find_owner(area_shape_index)
	var other_shape_node : CollisionShape2D = area.shape_owner_get_owner(other_shape_owner)
	print("AREA1: shape entered OSO=" + str(other_shape_owner)+" OSN="+ str(other_shape_node))

	var local_shape_owner = area1.shape_find_owner(local_shape_index)
	var local_shape_node : CollisionShape2D = area1.shape_owner_get_owner(local_shape_owner)
	print("AREA1: shape entered LSO=" + str(local_shape_owner)+" LSN="+ str(local_shape_node))
	
	var other_glob_tranf = other_shape_node.get_global_transform()
	var local_glob_transf = local_shape_node.get_global_transform()
	print("other glotransf="+str(other_glob_tranf))
	print("local glotransf="+str(local_glob_transf))
	
	var other_rect : Rect2 = other_shape_node.shape.get_rect()
	other_rect.position += other_glob_tranf.origin
	var local_rect : Rect2 = local_shape_node.shape.get_rect()
	local_rect.position += local_glob_transf.origin
	print("other rect="+str(other_rect))
	print("local rect="+str(local_rect))
	
	drop_area_surface = local_rect.get_area()
	moving_area_surface = other_rect.get_area()

	var intersect : Rect2 = local_rect.intersection(other_rect)
	var surface = intersect.get_area()
	print("Intersect="+str(intersect)+" area="+str(surface))
	debug_intersect = intersect
	

func _on_area_2d_1_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("Area1: shape exit sig: area="+str(area))


func _on_area_2d_2_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("Area2: shape ent sig: area="+str(area))
	var other_shape_owner = area.shape_find_owner(area_shape_index)
	var other_shape_node : CollisionShape2D = area.shape_owner_get_owner(other_shape_owner)
	print("AREA2: shape entered OSO=" + str(other_shape_owner)+" OSN="+ str(other_shape_node))

	var local_shape_owner = area2.shape_find_owner(local_shape_index)
	var local_shape_node = area2.shape_owner_get_owner(local_shape_owner)
	print("AREA2: shape entered LSO=" + str(local_shape_owner)+" LSN="+ str(local_shape_node))


func _on_area_2d_2_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("Area1: shape exit sig: area="+str(area))
