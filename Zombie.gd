extends Area2D
onready var sprite = $Sprite
var pos = null
var row = 1
var col = 1
var ruta: Array
var ia
var idx = 0
var vel = 10
var dt = 0
var inicio: Vector2
var last_move = null
var globals

func _ready():
	globals = get_node("/root/Globals")
	ia = get_node("/root/Main/Algoritmos")
	ia.setup(get_node("/root/Main/Mapa"))
	position.x = row * globals.tile_size
	position.y = col * globals.tile_size
	position += Vector2.ONE * globals.tile_size/2
	inicio = Vector2(col, row)
	
func _process(delta):
	dt += delta
	if dt >= float(1)/float(10):
		if idx < len(ruta):
			position.x = ruta[idx].x * globals.tile_size
			position.y = ruta[idx].y * globals.tile_size
			position += Vector2.ONE * globals.tile_size/2
			if last_move != null:
				move(get_dir(last_move, ruta[idx]))
			last_move = ruta[idx]
			inicio = ruta[idx]
			idx += 1
		dt -= float(1)/float(10)

func move(dir):
	match dir:
		"ui_right":
			sprite.rotation_degrees = 0
		"ui_left":
			sprite.rotation_degrees = 180
		"ui_up":
			sprite.rotation_degrees = 270
		"ui_down":
			sprite.rotation_degrees = 90
	#if dir != "static":
		#move_tween(dir)

func get_dir(p1, p2):
	if p2.x == p1.x + 1:
		return "ui_right"
	if p2.x == p1.x - 1:
		return "ui_left"
	if p2.y == p1.y + 1:
		return "ui_down"
	if p2.y == p1.y - 1:
		return "ui_up"
	return "static"

func _on_Player_update_pos(x, y):
	pos = Vector2(x, y)
	if not (pos in ruta):
		ruta = ia.BFS(inicio, pos)
		idx = 0
		last_move = inicio
		
func _on_Zombie_area_entered(area):
	$Dead.play()
	
