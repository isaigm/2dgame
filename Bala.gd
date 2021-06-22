extends Area2D
onready var sprite = $Sprite
var speed: Vector2

func _ready():
	sprite.rotation_degrees = 90
	
func _process(delta):
	position += speed * delta
	
func _on_Area2D_body_entered(body):
	queue_free()

func _on_Area2D_area_entered(area: Area2D):
	queue_free()
	area.queue_free()
	
