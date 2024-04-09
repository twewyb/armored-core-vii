extends Node3D

var cam
var altcam

# Called when the node enters the scene tree for the first time.
func _ready():

	altcam = $PhantomCamera3D
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_lock():
	_switch_cam()
	pass # Replace with function body.

func _switch_cam():
	if altcam.get_priority() != 10:
		altcam.set_priority(10)
	else :
		altcam.set_priority(0)
