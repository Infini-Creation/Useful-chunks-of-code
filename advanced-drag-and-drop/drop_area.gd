extends Node2D
class_name DropArea


@export var did : int = -1

@export var SnapDistanceThreshold : float = 125.0 #could be greater
@export var SnapEnabled : bool = false
@export var keepObject : bool = false
@export var rotAngle : float = 0.0
@export var CardTypesAllowed : int = 0

#add maybe an area of influence, when a card is in it => start making
# it acting differently, be more and more attracted by the dropspot center, like a blackhole

signal grabbed_something(object : Node2D)


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

	if object_grabbed != null:
		CardToSpotDistance = global_position.distance_to(object_grabbed.global_position)
		#print("CSD="+str(CardToSpotDistance))
		if CardToSpotDistance > SnapDistanceThreshold:
			print("CD: rotate card back")
			if object_grabbed.rotation != 0.0:
				animation = self.create_tween().set_parallel(false)
				var tp : PropertyTweener = animation.parallel().tween_property(object_grabbed, "rotation", 0, 0.5)
				tp.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				animation.play()
			object_grabbed = null
			full = false
						
	if full == false:
		$Label.text = "DropSpot is free"
	else:
		$Label.text = "Item grabbed"
	


func grabObject(something : Node2D) -> void:
	var tp : PropertyTweener
	
	#print("DA["+str(did)+"]: grab object="+str(something))
	if full == false:
		if something != null:
			object_grabbed = something as Card
			#if something.is_inside_tree() == true:
				#print("object already in the tree")
				#something.get_parent().remove_child(something)
					#make object "disappear"
			#add_child(something)
			if CardTypesAllowed != 0:
				print("This dropspot only accept cards of type: "+str(CardTypesAllowed))
				if something.Type != 0:
					print("Card type is:"+str(something.Type))
					if something.Type | CardTypesAllowed == 1:
						print("Card is accepted by the drop spot")
					else:
						print("Card is denied")
						return
			
			#print("object angle="+str(rad_to_deg(something.rotation)))
			#print("spot angle="+str(rad_to_deg(rotation)))
			
			if something.rotation != rotation:
				#print("angles are not equal, rotate...")
				var angle : float = rotation - something.rotation
				animation = self.create_tween().set_parallel(false)
				tp = animation.parallel().tween_property(something, "rotation", angle, 0.75)
				tp.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				animation.play()
			#else:
				#pass

			grabbed_something.emit(something) #signal ~useless
			full = true

			animation = self.create_tween().set_parallel(false)
			tp = animation.parallel().tween_property(something, "global_position", global_position, 0.25)
			tp.set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT_IN)
			something.did = did

			if keepObject == true:
				something.locked = true
	else:
		print("dropSpot not free")


#~keep a global list of cards in play and use id to get instance or just pass instance ref here
func _on_card_is_dropped_received(card : Node2D, cposition : Vector2) -> void:
	#print("card dropped sig received from card "+str(card.cid)+" on position: "+str(cposition))
	CardToSpotDistance = global_position.distance_to(cposition)
	#print("Dist to card spot ["+str(did)+"]: "+str(CardToSpotDistance)+"  ST="+str(SnapDistanceThreshold))
	
	if CardToSpotDistance <= SnapDistanceThreshold:
		grabObject(card)


func _on_button_pressed() -> void:
	if object_grabbed != null:
		print("release item")
		object_grabbed.locked = false
		object_grabbed.did = -1
		full = false


func get_size() -> Vector2:
	return $TextureRect.size
