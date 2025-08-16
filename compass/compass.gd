extends Node2D
class_name Compass

@export var Target : Node = null
@export var Owner : Node = null
@export var CompassMode : MODE #= MODE.INSTANTANEOUS
@export var Latency : float = 10.0	# for sluggish mode
	# 0.3 pretty fast enough
	# 0.005 quite laggy, 0.009 is better
@onready var Needle = $Needle

enum STATUS { AVAILABLE, DISABLED }
enum MODE { INSTANTANEOUS, SLUGGISH }

var status : int = STATUS.AVAILABLE
var center : Vector2i = Vector2i.ZERO
var gamePaused : bool = false


func _ready() -> void:
	#print(" M="+str(CompassMode))
	if Owner == null or Target == null:
		status = STATUS.DISABLED

	if CompassMode == MODE.INSTANTANEOUS:
		Latency = 0.1
	else:
		Latency = 0.009
		
	#print("mode="+str(CompassMode)+"  lat="+str(Latency))


func _process(_delta: float) -> void:
	match (status):
		STATUS.DISABLED:
			return
	Needle.rotation = lerp_angle(Needle.rotation, (Target.global_position-Owner.global_position).normalized().angle(), Latency)
