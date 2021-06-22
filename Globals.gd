extends Node

var inputs = {"ui_right": Vector2.RIGHT, "ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN}
var tile_size = 32
var monedas = 12
var zombies = 8
var nivel_actual = 1
func get_pos(row, col):
	var pos: Vector2
	pos.x = col * tile_size
	pos.y = row * tile_size
	pos += Vector2.ONE * tile_size/2
	return pos
	
func _ready():
	pass # Replace with function body.



