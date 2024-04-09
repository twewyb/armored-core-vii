extends PathFollow3D

func _process(delta):
	progress_ratio += .07  * delta
	
