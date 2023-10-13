extends Node2D
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 2.0
	timer.one_shot = true
	
	timer.connect("timeout", self.timeout)
	pass # Replace with function body.

func timeout():
	$"..".game_restart()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if area.get_groups().has("puck"):
		print("maali")
		timer.start()
	pass # Replace with function body.
