extends RigidBody2D

var wallsound = preload("res://audio/puckhitwall.mp3")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $PinJoint2D.get_node_b():
		
		var nodeb = get_node($PinJoint2D.get_node_b())
		if (position - nodeb.position).length() > 50:
			$PinJoint2D.set_node_b("")
			
			position = lerp(global_transform.origin, nodeb.position, delta*10) 
			$PinJoint2D.set_node_b(nodeb.get_path())
		elif nodeb.linear_velocity.length() > 200:
			$PinJoint2D.set_node_b("")
			position = lerp(global_transform.origin, nodeb.position + nodeb.linear_velocity*2, delta) 
			$PinJoint2D.set_node_b(nodeb.get_path())
		
	pass


func _on_area_2d_body_entered(body):
	if body.get_groups().has("players"):
		print("linear velo: " + str((linear_velocity - body.linear_velocity).length()))
		if (linear_velocity - body.linear_velocity).length() < 1850:
			$PinJoint2D.set_node_b(body.get_path())
			body.isCarryingPuck = true
		else:
			linear_velocity = linear_velocity/8
		
	match body.get_groups():
		["walls"]:
			$"../AudioStreamPlayer2D".stream = wallsound
			$"../AudioStreamPlayer2D".play()
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	if body.get_groups().has("players"):
		body.isCarryingPuck = false
	pass # Replace with function body.
