extends CanvasLayer


func set_titulo(flag: bool):
	if flag:
		$PanelContainer/MarginContainer/VBoxContainer/Label.text = "GANASTE!!"
		$PanelContainer/MarginContainer/VBoxContainer/Label.modulate = Color.green
	else:
		$PanelContainer/MarginContainer/VBoxContainer/Label.text = "HAS MUERTO"
		$PanelContainer/MarginContainer/VBoxContainer/Label.modulate = Color.red

func _ready():
	pass

func _on_Salir_pressed():
	get_tree().quit()

func _on_Reiniciar_pressed():
	get_tree().change_scene("res://Main.tscn")
