extends Node2D

export var m_iMovementRange: int = 3

onready var m_nFloorTileMap: TileMap = get_parent().get_node("Floor")

onready var m_vCellPos: Vector2
onready var m_bIsSelected: bool = false
onready var m_avCellsInRange: Array

func _ready():
	m_nFloorTileMap.connect("cell_selected", self, "_on_cell_selected")
	_set_pos(Vector2.ZERO)

func _set_pos(_vCellPos: Vector2):
	m_vCellPos = _vCellPos
	position = m_nFloorTileMap.to_global(m_nFloorTileMap.map_to_world(m_vCellPos))

func _on_cell_selected(_vCellPos: Vector2):
	if !m_bIsSelected:
		if _vCellPos == m_vCellPos:
			m_bIsSelected = true
			m_avCellsInRange = m_nFloorTileMap.get_cells_in_range(m_vCellPos, m_iMovementRange)
			m_nFloorTileMap.highlight_cells(m_avCellsInRange)
	else:
		if m_avCellsInRange.has(_vCellPos):
			m_bIsSelected = false
			_set_pos(_vCellPos)
			m_nFloorTileMap.highlight_cells([])
