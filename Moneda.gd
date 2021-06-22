extends Area2D

var globals
var row = 1
var col = 1
func _ready():
	globals = get_node("/root/Globals")
	position = globals.get_pos(row, col)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
