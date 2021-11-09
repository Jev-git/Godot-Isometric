extends Area2D

onready var m_nTileMap: TileMap = get_parent()

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			print_debug(m_nTileMap.world_to_map(m_nTileMap.to_local(get_global_mouse_position())))
