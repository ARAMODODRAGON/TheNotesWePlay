extends Node
class_name SoundReactive

signal on_sound_heard(note: int)

@export var listen_for_note_a : bool = true
@export var listen_for_note_b : bool = true
@export var listen_for_note_x : bool = true
@export var listen_for_note_y : bool = true
@export var listen_for_dud : bool = true


func m_on_played(note : int):
	if note == SoundSpace.NOTE_A and not listen_for_note_a: return
	if note == SoundSpace.NOTE_B and not listen_for_note_b: return
	if note == SoundSpace.NOTE_X and not listen_for_note_x: return
	if note == SoundSpace.NOTE_Y and not listen_for_note_y: return
	if note == SoundSpace.DUD and not listen_for_dud: return
	
	on_sound_heard.emit(note)

func _ready() -> void:
	SoundSpace.on_note_played.connect(m_on_played)
