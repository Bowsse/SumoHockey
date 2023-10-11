extends Line2D

var length = 30
var point = Vector2()


func _process(delta):
	global_position = Vector2(0,0)
	global_rotation = 0
	
	if $".."/"..".timer.time_left > 0:
		clear_points()
	
	point = get_parent().global_position
	

	add_point(point)
	
	
	while get_point_count()>length:
		remove_point(0)
	
func _ready():
	modulate.a = 0.4
	pass
