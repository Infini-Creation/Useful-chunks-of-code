extends Node2D

var one_dropspot_scene = preload("res://one_dropspot.tscn")
var rotated_dropspot_scene = preload("res://rotatedCD_scene.tscn")
var multiple_dropspots_scene = preload("res://many_cards_and_drop_spots.tscn")
var mdp_with_card_type_scene = preload("res://many_cards_and_drop_spots_ct.tscn")

var od_inst
var rd_inst
var md_inst
var mdct_inst

func _process(_delta: float) -> void:
	if od_inst != null:
		if od_inst.get_back == true:
			if od_inst.is_inside_tree() == true:
				od_inst.get_back = false
				remove_child(od_inst)
			$CenterContainer/HBoxContainer.show()

	if rd_inst != null:
		if rd_inst.get_back == true:
			if rd_inst.is_inside_tree() == true:
				rd_inst.get_back = false
				remove_child(rd_inst)
			$CenterContainer/HBoxContainer.show()

	if md_inst != null:
		if md_inst.get_back == true:
			if md_inst.is_inside_tree() == true:
				md_inst.get_back = false
				remove_child(md_inst)
			$CenterContainer/HBoxContainer.show()

	if mdct_inst != null:
		if mdct_inst.get_back == true:
			if mdct_inst.is_inside_tree() == true:
				mdct_inst.get_back = false
				remove_child(mdct_inst)
			$CenterContainer/HBoxContainer.show()


func _on_button_pressed() -> void:
	od_inst = one_dropspot_scene.instantiate()
	$CenterContainer/HBoxContainer.hide()
	add_child(od_inst)


func _on_button_2_pressed() -> void:
	rd_inst = rotated_dropspot_scene.instantiate()
	$CenterContainer/HBoxContainer.hide()
	add_child(rd_inst)


func _on_button_3_pressed() -> void:
	md_inst = multiple_dropspots_scene.instantiate()
	$CenterContainer/HBoxContainer.hide()
	add_child(md_inst)


func _on_button_4_pressed() -> void:
	mdct_inst = mdp_with_card_type_scene.instantiate()
	$CenterContainer/HBoxContainer.hide()
	add_child(mdct_inst)
