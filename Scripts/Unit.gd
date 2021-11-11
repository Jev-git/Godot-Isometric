extends Sprite
class_name Unit

export var m_iHP: int = 3
export var m_iMovementRange: int = 3
export var m_vStartingPos: Vector2
export var m_iWeapon: int

onready var m_vCellPos: Vector2
onready var m_nWeaponTexture: Texture = load(CONSTANTS.WEAPON_TEXTURE_PATHS[m_iWeapon])

func set_pos(_vCellPos: Vector2, _vScreenPos: Vector2):
	m_vCellPos = _vCellPos
	z_index = m_vCellPos.x + m_vCellPos.y
	position = _vScreenPos
