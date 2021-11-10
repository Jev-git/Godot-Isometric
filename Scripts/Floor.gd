extends TileMap

export var m_psHighlightCell: PackedScene

onready var m_nCursor: Sprite = $Cursor
onready var m_nHighlightCells: Node2D = $HighlightCells

onready var m_avObstacles: Array = get_parent().get_node("Obstacle").get_used_cells()

onready var m_vCursorPos: Vector2

signal cell_selected(vCellPos)

func _ready():
	for vCellPos in get_used_cells():
		var nHighlightCell: Sprite = m_psHighlightCell.instance()
		nHighlightCell.position = map_to_world(vCellPos)
		nHighlightCell.visible = false
		nHighlightCell.m_vCellPos = vCellPos
		m_nHighlightCells.add_child(nHighlightCell)

func _process(delta):
	var vCellPos = world_to_map(to_local(get_global_mouse_position()))
	if vCellPos.x >= 0 and vCellPos.x < CONSTANTS.BOARD_SIZE.x \
		and vCellPos.y >= 0 and vCellPos.y < CONSTANTS.BOARD_SIZE.y:
		_set_cursor_pos(vCellPos)
	else:
		_hide_cursor()

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and m_nCursor.visible:
			emit_signal("cell_selected", m_vCursorPos)

func _hide_cursor():
	m_nCursor.visible = false

func _set_cursor_pos(_vCellPos: Vector2):
	m_nCursor.visible = true
	m_vCursorPos = _vCellPos
	m_nCursor.position = map_to_world(_vCellPos)

func highlight_cells(_avCells: Array):
	for nHighlightCell in m_nHighlightCells.get_children():
		if _avCells.has(nHighlightCell.m_vCellPos):
			nHighlightCell.visible = true
		else:
			nHighlightCell.visible = false

func get_cells_in_range(_vCellPos: Vector2, _iRange: int) -> Array:
	var aResults: Array = []
	for iX in range(max(_vCellPos.x - _iRange, 0), min(_vCellPos.x + _iRange + 1, CONSTANTS.BOARD_SIZE.x)):
		for iY in range(max(_vCellPos.y - _iRange, 0), min(_vCellPos.y + _iRange + 1, CONSTANTS.BOARD_SIZE.y)):
			if abs(iX - _vCellPos.x) + abs(iY - _vCellPos.y) <= _iRange \
			and !m_avObstacles.has(Vector2(iX, iY)):
				aResults.append(Vector2(iX, iY))
	return aResults
