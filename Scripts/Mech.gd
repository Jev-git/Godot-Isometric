extends Node2D
class_name Mech

export var m_iMovementRange: int = 3
export var m_vStartingPos: Vector2 = Vector2.ZERO

onready var m_vCellPos: Vector2

func set_pos(_vCellPos: Vector2, _vScreenPos: Vector2):
	m_vCellPos = _vCellPos
	z_index = m_vCellPos.x + m_vCellPos.y
	position = _vScreenPos
