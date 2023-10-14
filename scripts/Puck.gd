extends RigidBody2D
var wallsound = preload("res://audio/puckhitwall.mp3")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var puckPos = global_position
	if $PinJoint2D.get_node_b():
		$"../SpritePuck".global_position = $"../SpritePuck".global_position.lerp(puckPos, delta * 15)
	else:
		$"../SpritePuck".global_position = position
	
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $PinJoint2D.get_node_b():
		var nodeb = get_node($PinJoint2D.get_node_b())
		if (position - nodeb.position).length() > 35:
			position = position - (position - nodeb.position)* delta * 9
		if nodeb.linear_velocity.length() > 150:
			position = position + nodeb.linear_velocity*2 * delta
	pass


func _on_area_2d_body_entered(body):
	if body.get_groups().has("players"):
		if (linear_velocity - body.linear_velocity).length() < 1850 && !body.speedbursting:
			$PinJoint2D.set_node_b(body.get_path())
			body.isCarryingPuck = true
		else:
			linear_velocity = (linear_velocity/8) + (body.position - position)*2
	match body.get_groups():
		["walls"]:
			$"../AudioStreamPlayer2D".stream = wallsound
			$"../AudioStreamPlayer2D".play()
	pass # Replace with function body.

func _on_area_2d_body_exited(body):
	if body.get_groups().has("players"):
		body.isCarryingPuck = false
	pass # Replace with function body.

func _on_show_real_puck_button_down():
	if visible:
		visible = false
	else:
		visible = true
	pass # Replace with function body.
