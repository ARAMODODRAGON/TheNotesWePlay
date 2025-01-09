extends Node

const DUD : int = -1
const NOTE_A : int = 0
const NOTE_B : int = 1
const NOTE_X : int = 2
const NOTE_Y : int = 3

# check this to see what the current state is
var current_note : int = DUD

# subscribe to these signals
signal on_note_played(note: int)
signal on_note_changed(note: int)

func _note_to_string(note: int) -> String:
	match note:
		DUD:    return "DUD"
		NOTE_A: return "NOTE_A"
		NOTE_B: return "NOTE_B"
		NOTE_X: return "NOTE_X"
		NOTE_Y: return "NOTE_Y"
	return ""

# call this function
func play_note(note: int) -> void:
	on_note_played.emit(note)
	if note != current_note:
		on_note_changed.emit(note)
	
	current_note = note
	
	print("played note: " + _note_to_string(note))
	pass
