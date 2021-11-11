extends Sprite

var m_vCellPos: Vector2

func set_highlight_color(_bIsMovementHighlight: bool = true):
	set_modulate(Color.green if _bIsMovementHighlight else Color.orange)
