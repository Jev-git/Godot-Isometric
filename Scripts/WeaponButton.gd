extends Button

var m_nMech: Unit

onready var m_nFloorTileMap: TileMap = get_parent().get_node("Floor")

func _ready():
	connect("toggled", self, "_on_button_toggle")

func set_mech(_nMech: Unit):
	m_nMech = _nMech
	visible = true
	icon = m_nMech.m_nWeaponTexture

func _on_button_toggle(_bIsButtonPressed: bool):
	if _bIsButtonPressed:
		m_nFloorTileMap.highlight_cells(m_nFloorTileMap.get_cells_in_attack_range(m_nMech.m_vCellPos, m_nMech.m_iWeapon), false)
