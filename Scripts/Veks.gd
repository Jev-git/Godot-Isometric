extends Node2D

onready var m_nFloorTileMap: TileMap = get_parent().get_node("Floor")

func _ready():
	for nUnit in get_children():
		nUnit.set_pos(nUnit.m_vStartingPos, m_nFloorTileMap.to_global(m_nFloorTileMap.map_to_world(nUnit.m_vStartingPos)))
