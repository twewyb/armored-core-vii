extends MeshInstance3D

func _process(delta):
	var v = Input.get_vector("ui_left","ui_right","ui_down","ui_up")
	var dir = Vector3(v.x,v.y,0)
	position += dir*5*delta
