extends RigidBody2D

var wallsound = preload("res://audio/puckhitwall.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $PinJoint2D.get_node_b():
		
		var nodeb = get_node($PinJoint2D.get_node_b())
		print(nodeb.linear_velocity.length())
		if (position - nodeb.position).length() > 40:
			$PinJoint2D.set_node_b("")
			
			position = lerp(global_transform.origin, nodeb.position, delta*10) 
			$PinJoint2D.set_node_b(nodeb.get_path())
		elif nodeb.linear_velocity.length() > 200:
			$PinJoint2D.set_node_b("")
			position = lerp(global_transform.origin, nodeb.position + nodeb.linear_velocity/2, delta*4) 
			$PinJoint2D.set_node_b(nodeb.get_path())
		
	pass


func _on_area_2d_body_entered(body):
	print(body.get_groups())
	if body.get_groups().has("players"):
		$PinJoint2D.set_node_b(body.get_path())
		body.isCarryingPuck = true
		
	match body.get_groups():
		["walls"]:
			$"../AudioStreamPlayer2D".stream = wallsound
			$"../AudioStreamPlayer2D".play()
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	print(body.get_groups())
	if body.get_groups().has("players"):
		body.isCarryingPuck = false
	pass # Replace with function body.
