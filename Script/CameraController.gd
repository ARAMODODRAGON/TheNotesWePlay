extends Camera2D

var player : Player = null

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null: return;
	
	position.x = player.position.x
