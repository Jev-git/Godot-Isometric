extends TileMap

onready var m_vCurrentHighlightCell: Vector2

func _process(delta):
	var vCellPos = world_to_map(to_local(get_global_mouse_position()))
	if vCellPos.x >= 0 and vCellPos.x < CONSTANTS.BOARD_SIZE.x \
		and vCellPos.y >= 0 and vCellPos.y < CONSTANTS.BOARD_SIZE.y:
		_high_light_cell(vCellPos)
	else:
		_unhighlight_cell()

func _unhighlight_cell():
	set_cellv(m_vCurrentHighlightCell, 0)

func _high_light_cell(_vCellPos: Vector2):
	set_cellv(m_vCurrentHighlightCell, 0)
	m_vCurrentHighlightCell = _vCellPos
	set_cellv(m_vCurrentHighlightCell, 2)
