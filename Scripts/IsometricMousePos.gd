extends TileMap

func _process(delta):
	var vTilePos = world_to_map(to_local(get_global_mouse_position()))
	if vTilePos.x >= 0 and vTilePos.x <= CONSTANTS.BOARD_SIZE.x \
		and vTilePos.y >= 0 and vTilePos.y <= CONSTANTS.BOARD_SIZE.y:
		print_debug(vTilePos)
