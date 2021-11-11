extends Node2D

onready var m_nFloorTileMap: TileMap = get_parent().get_node("Floor")
onready var m_nWeaponButton: Button = get_parent().get_node("WeaponButton")

onready var m_nSelectedMech: Unit = null
onready var m_avCellsInRange: Array

func _ready():
	m_nFloorTileMap.connect("cell_selected", self, "_on_cell_selected")
	for nMech in get_children():
		nMech.set_pos(nMech.m_vStartingPos, m_nFloorTileMap.to_global(m_nFloorTileMap.map_to_world(nMech.m_vStartingPos)))

func _on_cell_selected(_vCellPos: Vector2):
	if !m_nSelectedMech:
		for nMech in get_children():
			if _vCellPos == nMech.m_vCellPos:
				m_nSelectedMech = nMech
				m_avCellsInRange = m_nFloorTileMap.get_cells_in_range(_vCellPos, nMech.m_iMovementRange)
				for nnMech in get_children():
					if m_avCellsInRange.has(nnMech.m_vCellPos):
						m_avCellsInRange.erase(nnMech.m_vCellPos)
				m_nFloorTileMap.highlight_cells(m_avCellsInRange)
				
				m_nWeaponButton.icon = nMech.m_nWeaponTexture
				break
	else:
		if m_avCellsInRange.has(_vCellPos):
			m_nFloorTileMap.highlight_cells([])
			m_nSelectedMech.set_pos(_vCellPos, m_nFloorTileMap.to_global(m_nFloorTileMap.map_to_world(_vCellPos)))
			m_nWeaponButton.icon = null
			m_nSelectedMech = null
