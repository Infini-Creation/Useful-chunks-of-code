extends Node2D
class_name DropArea


@export var did : int = -1

@export var SnapDistanceThreshold : float = 65.0
@export var SnapEnabled : bool = false
@export var keepObject : bool = false
@export var rotAngle : float = 0.0

signal grabbed_something(object : Node2D)

var object : Node2D
var CardToSpotDistance : float = 0.0
var full : bool = false
var object_grabbed : Node2D

var animation : Tween

#different behavior: snap on/off, sticky/grab (lock dropped item), ...

func _ready() -> void:
	if rotAngle != 0.0:
		rotate(deg_to_rad(rotAngle))
	if keepObject == false:
		$Button.disabled = true


func _process(_delta: float) -> void:
	if full == false:
		$Label.text = "DropSpot is free"
	else:
		$Label.text = "Item grabbed"


func grabObject(something : Node2D) -> void:
	print("DA["+str(did)+"]: grab object="+str(something))
	if full == false:
		if something != null:
			object_grabbed = something
			if something.is_inside_tree() == true:
				print("object already in the tree")
				#something.get_parent().remove_child(something)
					#make object "disappear"
			#add_child(something)
			
			print("object angle="+str(rad_to_deg(something.rotation)))
			print("spot angle="+str(rad_to_deg(rotation)))
			
			if something.rotation != rotation:
				print("angles are not equal, rotate...")
				var angle : float = rotation - something.rotation
				animation = self.create_tween().set_parallel(false)
				var tp : PropertyTweener = animation.parallel().tween_property(something, "rotation", angle, 0.75)
				tp.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				animation.play()
			
			#somewhere here manage unlocked item
			# when dist > treshold, dropspot is free again
			# if angle modfied, item get its angle then
			
			grabbed_something.emit(something) #signal ~useless
			full = true
			#tween here
			something.global_position = global_position
			if keepObject == true:
				something.locked = true
	else:
		print("dropSpot not free")


#~keep a globa list of cards in play and use id to get instance or just pass instance ref here
func _on_card_is_dropped_received(card : Node2D, cposition : Vector2) -> void:
	print("card dropped sig received from card "+str(card.cid)+" on position: "+str(cposition))
	CardToSpotDistance = global_position.distance_to(cposition)
	print("Dist to card spot ["+str(did)+"]: "+str(CardToSpotDistance)+"  ST="+str(SnapDistanceThreshold))
	
	if CardToSpotDistance <= SnapDistanceThreshold:
		grabObject(card)


func _on_button_pressed() -> void:
	if object_grabbed != null:
		print("release item")
		object_grabbed.locked = false
		full = false


func get_size() -> Vector2:
	return $TextureRect.size
