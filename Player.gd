extends Area2D
export (PackedScene) var Bala

onready var ray = $RayCast2D
onready var tween = $Tween
onready var sprite = $Sprite
const deadScreen = preload("res://DeadScreen.tscn")
signal update_pos(x, y)
var vel = 10
var col = 35
var row = 10
var mapa
var globals
var puede_disparar = true
var vida = 100
var puntos = 0
func _input(event):
	if Input.is_key_pressed(KEY_SPACE) and puede_disparar:
		var bala = Bala.instance()
		var dir = sprite.rotation
		var cartesian = Vector2(cos(dir), sin(dir))
		bala.position = position + 25 * cartesian
		bala.rotation_degrees = sprite.rotation_degrees
		bala.speed = Vector2(300, 0)
		bala.speed = bala.speed.rotated(dir)
		puede_disparar = false
		$Timer.start()
		get_parent().add_child(bala)
		$Disparo.play()

func _ready():
	globals = get_node("/root/Globals")
	mapa = get_node("/root/Main/Mapa")
	position = globals.get_pos(row, col)
	$Pos.start()
	
func _process(_delta):
	if tween.is_active():
		return
	for dir in globals.inputs.keys():
		if Input.is_action_pressed(dir):
			move(dir)

func move(dir):
	ray.cast_to = globals.inputs[dir] * globals.tile_size #manda un vector que apunta en la misma direccion del jugador para detectar colisiones
	ray.force_raycast_update()
	if !ray.is_colliding():
		match dir:
			"ui_right":
				sprite.rotation_degrees = 0
			"ui_left":
				sprite.rotation_degrees = 180
			"ui_up":
				sprite.rotation_degrees = 270
			"ui_down":
				sprite.rotation_degrees = 90
		move_tween(dir)
			
func move_tween(dir): #movimiento suave entre cada tile
	tween.interpolate_property(self, "position",
		position, position + globals.inputs[dir] * globals.tile_size,
		1.0/vel, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _on_Player_area_entered(area):
	if area.is_in_group('Moneda'):
		$Coin.play()
		puntos += 1
		get_node("/root/Main/CanvasLayer/Control/Monedas").text = "Monedas: " + str(puntos)
		area.queue_free()
		if puntos == globals.monedas:
			if globals.nivel_actual == 1:
				get_tree().change_scene("res://Nivel2.tscn")
				globals.nivel_actual = 2
			elif globals.nivel_actual == 2:
				get_tree().change_scene("res://Nivel3.tscn")
				globals.nivel_actual = 3
			elif globals.nivel_actual == 3:
				var game_over = deadScreen.instance()
				game_over.set_titulo(true)
				add_child(game_over)
				get_tree().paused = true
				globals.nivel_actual = 1
		
	else:
		get_node("/root/Main/CanvasLayer/Control/Vida").value = vida
		vida -= 20
		if vida <= 0:
			globals.nivel_actual = 1
			var game_over = deadScreen.instance()
			game_over.set_titulo(false)
			add_child(game_over)
			get_tree().paused = true

func _on_Timer_timeout():
	puede_disparar = true


func _on_Pos_timeout():
	var pos = mapa.world_to_map(position)
	emit_signal("update_pos", pos.x, pos.y)
	$Pos.start()
