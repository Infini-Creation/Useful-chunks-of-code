extends Node2D

@onready var tilemaplayer : TileMapLayer

var tile_highlight : Texture2D = preload("res://tile-highlight.png")
var highlight : Sprite2D

var mouse_location : Vector2 = Vector2.ZERO
var mapcoord : Vector2i
var screencoord : Vector2i


func _ready() -> void:
	tilemaplayer = $"TileMapLayer-hex"

	highlight = Sprite2D.new()
	highlight.texture = tile_highlight
	highlight.z_index = 20
	highlight.centered = true
	add_child(highlight)
	

func _process(_delta: float) -> void:
	mouse_location = get_global_mouse_position() ##.snapped(Vector2(tilemaplayer.tile_set.tile_size))
	mapcoord = tilemaplayer.local_to_map(mouse_location)
		
	highlight.global_position = tilemaplayer.map_to_local(mapcoord)
