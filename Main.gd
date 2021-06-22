extends Node2D
export (PackedScene) var Zombie
export (PackedScene) var Moneda
onready var mapa = $Mapa
var rng = RandomNumberGenerator.new()
const ROCA = 5
const ROCA2 = 4
var rows: int
var cols: int
var globals
func _ready():
	globals = get_node("/root/Globals")
	rng.randomize()
	get_tree().paused = false
	var rect = mapa.get_used_rect()
	rows = rect.size.y + rect.position.y - 1
	cols = rect.size.x + rect.position.x - 1
	for n in range(globals.monedas):
		var moneda = Moneda.instance()
		var coords = spawn_object(rows, cols)
		moneda.row = coords[0]
		moneda.col = coords[1]
		add_child(moneda)
	for n in range(globals.zombies):
		var zombie = Zombie.instance()
		var coords = spawn_object(rows, cols)
		zombie.row = coords[0]
		zombie.col = coords[1]
		get_child(1).connect("update_pos", zombie, "_on_Player_update_pos")
		add_child(zombie)

func spawn_object(row, cols):
	var r = rng.randi() % rows
	var c = rng.randi() % cols
	while mapa.get_cell(c, r) == ROCA or mapa.get_cell(c, r) == ROCA2:	
		r = rng.randi() % rows
		c = rng.randi() % cols
	return [r, c]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
