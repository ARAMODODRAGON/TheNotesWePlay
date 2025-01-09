extends StaticBody2D

@export_range(0, 3) var note_type : int = 0

func _ready() -> void:
	$CollisionShape2D.disabled = true
	$Sprite2D.frame = note_type + 4

func _on_sound_heard(note: int) -> void:
	if note_type == note:
		$CollisionShape2D.disabled = false
		$Sprite2D.frame = note_type
	else:
		$CollisionShape2D.disabled = true
		$Sprite2D.frame = note_type + 4
