extends TileMap

export var m_psHighlightCell: PackedScene
export var m_psMountainSprite: PackedScene
export var m_psBuildingSprite: PackedScene

onready var m_nCursor: Sprite = $Cursor
onready var m_nHighlightCells: Node2D = $HighlightCells

onready var m_nMountainTileMap: TileMap = get_parent().get_node("MountainTileMap")
onready var m_nBuildingTileMap: TileMap = get_parent().get_node("BuildingTileMap")
onready var m_avMountainPos: Array = m_nMountainTileMap.get_used_cells()
onready var m_avBuildingPos: Array = m_nBuildingTileMap.get_used_cells()
onready var m_nMountains: Node2D = $Mountains
onready var m_nBuildings: Node2D = $Buildings

onready var m_nMechs: Node2D = get_parent().get_node("Mechs")
onready var m_nVeks: Node2D = get_parent().get_node("Veks")

onready var m_vCursorPos: Vector2

signal cell_selected(vCellPos)

func _ready():
	for vCellPos in get_used_cells():
		var nHighlightCell: Sprite = m_psHighlightCell.instance()
		nHighlightCell.position = map_to_world(vCellPos)
		nHighlightCell.visible = false
		nHighlightCell.m_vCellPos = vCellPos
		m_nHighlightCells.add_child(nHighlightCell)
	
	for vCellPos in m_avMountainPos:
		m_nMountainTileMap.set_cellv(vCellPos, -1)
		var nMountainSprite: Sprite = m_psMountainSprite.instance()
		nMountainSprite.position = map_to_world(vCellPos)
		nMountainSprite.z_index = vCellPos.x + vCellPos.y
		m_nMountains.add_child(nMountainSprite)
	
	for vCellPos in m_avBuildingPos:
		m_nBuildingTileMap.set_cellv(vCellPos, -1)
		var nBuildingSprite: Sprite = m_psBuildingSprite.instance()
		nBuildingSprite.position = map_to_world(vCellPos)
		nBuildingSprite.z_index = vCellPos.x + vCellPos.y
		m_nBuildings.add_child(nBuildingSprite)

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
			and !m_avMountainPos.has(Vector2(iX, iY)) and !m_avBuildingPos.has(Vector2(iX, iY)):
				aResults.append(Vector2(iX, iY))
	return aResults

func get_cells_in_attack_range(_vCellPos: Vector2, _iWeapon: int) -> Array:
	var aResults: Array = []
	
	var avNonEmptyCells: Array = []
	avNonEmptyCells.append_array(m_avMountainPos)
	avNonEmptyCells.append_array(m_avBuildingPos)
	
	for nMech in m_nMechs.get_children():
		avNonEmptyCells.append(nMech.m_vCellPos)
	for nVek in m_nVeks.get_children():
		avNonEmptyCells.append(nVek.m_vCellPos)
	
	match _iWeapon:
		CONSTANTS.WEAPONS.TITAN_FIST:
			if _vCellPos.x > 0: aResults.append(_vCellPos + Vector2(-1, 0))
			if _vCellPos.x < CONSTANTS.BOARD_SIZE.x - 1: aResults.append(_vCellPos + Vector2(1, 0))
			if _vCellPos.y > 0: aResults.append(_vCellPos + Vector2(0, -1))
			if _vCellPos.y < CONSTANTS.BOARD_SIZE.y - 1: aResults.append(_vCellPos + Vector2(0, 1))
		CONSTANTS.WEAPONS.TAURUS_CANNON:
			for iX in range(_vCellPos.x - 1, -1, -1):
				var vCell: Vector2 = Vector2(iX, _vCellPos.y)
				aResults.append(vCell)
				if avNonEmptyCells.has(vCell):
					break
			for iX in range(_vCellPos.x + 1, CONSTANTS.BOARD_SIZE.x):
				var vCell: Vector2 = Vector2(iX, _vCellPos.y)
				aResults.append(vCell)
				if avNonEmptyCells.has(vCell):
					break
			for iY in range(_vCellPos.y - 1, -1, -1):
				var vCell: Vector2 = Vector2(_vCellPos.x, iY)
				aResults.append(vCell)
				if avNonEmptyCells.has(vCell):
					break
			for iY in range(_vCellPos.y + 1, CONSTANTS.BOARD_SIZE.y):
				var vCell: Vector2 = Vector2(_vCellPos.x, iY)
				aResults.append(vCell)
				if avNonEmptyCells.has(vCell):
					break
		CONSTANTS.WEAPONS.ARTEMIS_ARTILLERY:
			for iX in range(_vCellPos.x - 2, -1, -1):
				aResults.append(Vector2(iX, _vCellPos.y))
			for iX in range(_vCellPos.x + 2, CONSTANTS.BOARD_SIZE.x):
				aResults.append(Vector2(iX, _vCellPos.y))
			for iY in range(_vCellPos.y - 2, -1, -1):
				aResults.append(Vector2(_vCellPos.x, iY))
			for iY in range(_vCellPos.y + 2, CONSTANTS.BOARD_SIZE.y):
				aResults.append(Vector2(_vCellPos.x, iY))
	return aResults
