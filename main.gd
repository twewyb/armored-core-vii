extends Node3D



func _ready():
	for child in $Enemy.get_children():
		if child is Area3D:
			connect("mouse_entered",_aimed)

func _aimed():
	print("aimed")
	pass
