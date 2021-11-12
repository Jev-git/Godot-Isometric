extends Node2D

onready var m_nFloorTileMap: TileMap = get_parent().get_node("Floor")
onready var m_nWeaponButton: Button = get_parent().get_node("WeaponButton")

onready var m_nSelectedMech: Unit = null
onready var m_avCellsInMovementRange: Array
onready var m_avCellsInAttackRange: Array

func _ready():
	m_nFloorTileMap.connect("cell_selected", self, "_on_cell_selected")
	m_nWeaponButton.connect("toggled", self, "_on_weapon_button_toggled")
	for nMech in get_children():
		nMech.set_pos(nMech.m_vStartingPos, m_nFloorTileMap.to_global(m_nFloorTileMap.map_to_world(nMech.m_vStartingPos)))

func _on_cell_selected(_vCellPos: Vector2):
	if !m_nSelectedMech:
		for nMech in get_children():
			if _vCellPos == nMech.m_vCellPos:
				_set_selected_mech(nMech)
				break
	else:
		if !m_nWeaponButton.pressed:
			if m_avCellsInMovementRange.has(_vCellPos):
				m_nSelectedMech.set_pos(_vCellPos, m_nFloorTileMap.to_global(m_nFloorTileMap.map_to_world(_vCellPos)))
				_unselect_mech()
			elif _vCellPos == m_nSelectedMech.m_vCellPos:
				_unselect_mech()
			else:
				for nMech in get_children():
					if _vCellPos == nMech.m_vCellPos:
						_set_selected_mech(nMech)
		elif m_nWeaponButton.pressed and m_avCellsInAttackRange.has(_vCellPos):
			print("attack")
			_unselect_mech()

func _on_weapon_button_toggled(_bIsPressed: bool):
	if _bIsPressed:
		m_nFloorTileMap.highlight_cells(m_avCellsInAttackRange, false)
	else:
		m_nFloorTileMap.highlight_cells(m_avCellsInMovementRange)

func _set_selected_mech(_nMech: Unit):
	m_nSelectedMech = _nMech
	m_avCellsInAttackRange = m_nFloorTileMap.get_cells_in_attack_range(_nMech.m_vCellPos, _nMech.m_iWeapon)
	m_avCellsInMovementRange = m_nFloorTileMap.get_cells_in_movement_range(_nMech.m_vCellPos, _nMech.m_iMovementRange)
	for nMech in get_children():
		if m_avCellsInMovementRange.has(nMech.m_vCellPos):
			m_avCellsInMovementRange.erase(nMech.m_vCellPos)
	m_nFloorTileMap.highlight_cells(m_avCellsInMovementRange)
	m_nWeaponButton.set_mech(m_nSelectedMech)

func _unselect_mech():
	m_nSelectedMech = null
	m_nWeaponButton.pressed = false
	m_nWeaponButton.visible = false
	m_nFloorTileMap.highlight_cells([])
