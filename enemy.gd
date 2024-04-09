extends Node3D

@export var weakpoints = [] 

func _ready():
	for child in get_children():
		if child is Area3D:
			weakpoints.append(child)
