extends TileMap

export var m_psHighlightCell: PackedScene
export var m_psObstacleSprite: PackedScene

onready var m_nCursor: Sprite = $Cursor
onready var m_nHighlightCells: Node2D = $HighlightCells

onready var m_nObstacleTileMap: TileMap = get_parent().get_node("ObstacleTileMap")
onready var m_avObstacles: Array = m_nObstacleTileMap.get_used_cells()
onready var m_nObstacles: Node2D = $Obstacles

onready var m_vCursorPos: Vector2

signal cell_selected(vCellPos)

func _ready():
	for vCellPos in get_used_cells():
		var nHighlightCell: Sprite = m_psHighlightCell.instance()
		nHighlightCell.position = map_to_world(vCellPos)
		nHighlightCell.visible = false
		nHighlightCell.m_vCellPos = vCellPos
		m_nHighlightCells.add_child(nHighlightCell)
	
	for vCellPos in m_avObstacles:
		m_nObstacleTileMap.set_cellv(vCellPos, -1)
		var nObstacleSprite: Sprite = m_psObstacleSprite.instance()
		nObstacleSprite.position = map_to_world(vCellPos)
		nObstacleSprite.z_index = vCellPos.x + vCellPos.y
		m_nObstacles.add_child(nObstacleSprite)

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

func highlight_cells(_avCells: Array, _bIsMovementHighlight: bool = true):
	for nHighlightCell in m_nHighlightCells.get_children():
		if _avCells.has(nHighlightCell.m_vCellPos):
			nHighlightCell.visible = true
			nHighlightCell.set_highlight_color(_bIsMovementHighlight)
		else:
			nHighlightCell.visible = false

func get_cells_in_movement_range(_vCellPos: Vector2, _iRange: int) -> Array:
	var aResults: Array = []
	for iX in range(max(_vCellPos.x - _iRange, 0), min(_vCellPos.x + _iRange + 1, CONSTANTS.BOARD_SIZE.x)):
		for iY in range(max(_vCellPos.y - _iRange, 0), min(_vCellPos.y + _iRange + 1, CONSTANTS.BOARD_SIZE.y)):
			if abs(iX - _vCellPos.x) + abs(iY - _vCellPos.y) <= _iRange \
			and !m_avObstacles.has(Vector2(iX, iY)):
				aResults.append(Vector2(iX, iY))
	return aResults

func get_cells_in_attack_range(_vCellPos: Vector2, _iWeapon: int) -> Array:
	var aResults: Array = []
	match _iWeapon:
		CONSTANTS.WEAPONS.TITAN_FIST:
			if _vCellPos.x > 0: aResults.append(_vCellPos + Vector2(-1, 0))
			if _vCellPos.x < CONSTANTS.BOARD_SIZE.x - 1: aResults.append(_vCellPos + Vector2(1, 0))
			if _vCellPos.y > 0: aResults.append(_vCellPos + Vector2(0, -1))
			if _vCellPos.y < CONSTANTS.BOARD_SIZE.y - 1: aResults.append(_vCellPos + Vector2(0, 1))
	return aResults
