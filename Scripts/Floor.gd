extends TileMap

onready var m_vCurrentHighlightCell: Vector2
onready var m_bIsHighlighting: bool = false

onready var m_avObstacles: Array = get_parent().get_node("Obstacle").get_used_cells()

func _process(delta):
	var vCellPos = world_to_map(to_local(get_global_mouse_position()))
	if vCellPos.x >= 0 and vCellPos.x < CONSTANTS.BOARD_SIZE.x \
		and vCellPos.y >= 0 and vCellPos.y < CONSTANTS.BOARD_SIZE.y:
		_high_light_cell(vCellPos)
	else:
		_unhighlight_cell()

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and m_bIsHighlighting and \
			!m_avObstacles.has(m_vCurrentHighlightCell):
			for vCell in _get_cells_in_range(m_vCurrentHighlightCell, 3):
				set_cellv(vCell, 2)

func _unhighlight_cell():
	m_bIsHighlighting = false
	set_cellv(m_vCurrentHighlightCell, 0)

func _high_light_cell(_vCellPos: Vector2):
	m_bIsHighlighting = true
	set_cellv(m_vCurrentHighlightCell, 0)
	m_vCurrentHighlightCell = _vCellPos
	set_cellv(m_vCurrentHighlightCell, 2)

func _get_cells_in_range(_vCellPos: Vector2, _iRange: int) -> Array:
	var aResults: Array = []
	for iX in range(max(_vCellPos.x - _iRange, 0), min(_vCellPos.x + _iRange + 1, CONSTANTS.BOARD_SIZE.x)):
		for iY in range(max(_vCellPos.y - _iRange, 0), min(_vCellPos.y + _iRange + 1, CONSTANTS.BOARD_SIZE.y)):
			if abs(iX - _vCellPos.x) + abs(iY - _vCellPos.y) <= _iRange \
			and !m_avObstacles.has(Vector2(iX, iY)):
				aResults.append(Vector2(iX, iY))
	return aResults
