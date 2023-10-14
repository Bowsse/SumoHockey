extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if $"..".isCarryingPuck:
		if (body.linear_velocity - $"..".linear_velocity).length() > 700:
			print((body.linear_velocity - $"..".linear_velocity).length())
			$".."/"..".find_child("Puck", true, false).find_child("PinJoint2D", true, false).set_node_b("")
		
	pass # Replace with function body.
