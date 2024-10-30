extends Node2D

@onready var viewport_area_bg: Polygon2D = $ViewportArea_Bg
@onready var boundary_wall_tilemap_layer: TileMapLayer = $BoundaryWall_TilemapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## these nodes should not be visible
	viewport_area_bg.visible = false
	boundary_wall_tilemap_layer.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
