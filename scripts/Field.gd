extends Area2D

var yscale = scale.y
var xscale = scale.x
var init_scale = scale
var wall = preload("res://scenes/packed_nodes/icewall.tscn")
var t


func _on_body_exit(body):
	if body.has_method("player_death"):
		body.player_death()

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameManager.icewallEnabled == true:
		t = wall.instantiate()
		add_child(t)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if scale > (init_scale / 3 ) && $"..".timer.time_left == 0:
		yscale = scale.y - (0.004 * delta)
		xscale = scale.x - (0.004 * delta)
		scale.y = yscale
		scale.x = xscale
func reset_wall():
	if GameManager.icewallEnabled == true:
		remove_child(t)
		t.queue_free()
		t = wall.instantiate()
		#var t = wall.instance()
		add_child(t)
	pass
