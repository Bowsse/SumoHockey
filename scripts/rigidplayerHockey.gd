extends RigidBody2D

var thrust = Vector2.ZERO
var torque = 1200
var max_speed = 550
var set_controllable = true
var fadeModulationAlpha = false

var spawnPosition
var playerId
var arrow = preload("res://scenes/packed_nodes/arrow.tscn")
var key_left = ""
var key_right = ""
var key_up = ""
var key_down = ""
var key_speedburst = ""
var speedbursting = false
var timer
var burstCD
var burstAvailable = false
var beforeBurstVelocity
var burstEnded = false
var burstSound = preload("res://audio/burstsound.mp3")
var burstAmplitude = 0.2
var isCarryingPuck = false
var slapshot = preload("res://audio/slapshot.mp3")


func speedburst(state, input):
	
	pass
func timeout():
	#print("not speeding")
	speedbursting = false
	burstEnded = true	

	pass	
func burstTimeout():
	burstAvailable = true
	$PlayerImage.value = 0
func _integrate_forces(state):
	
	if state.linear_velocity == Vector2.ZERO:
		arrow.rotation = (position - ($"..".find_children("center", "", true, false)[0]).position).angle()
	if set_controllable == true:
		if burstEnded:
			state.linear_velocity = state.linear_velocity.normalized()*beforeBurstVelocity.length()
			burstEnded = false
		var input = Vector2.ZERO
		input.x = int(Input.is_action_pressed(key_right)) - int(Input.is_action_pressed(key_left))
		input.y = int(Input.is_action_pressed(key_down)) - int(Input.is_action_pressed(key_up))
		if Input.is_action_pressed(key_speedburst) && burstAvailable && !isCarryingPuck:
			arrow.visible = true
			
			if arrow.modulate.a <= 0.2 && input != Vector2.ZERO:
				#arrow.rotation = (Vector2.ZERO - input).angle()
				arrow.rotation = (Vector2.ZERO - input).angle()
				#print(arrow.rotation)
			#arrow.rotation = (Vector2.ZERO - input).angle()
			var curRot = arrow.rotation
			if input != Vector2.ZERO:
				arrow.rotation = lerp_angle(curRot, (Vector2.ZERO - input).angle(), 0.05)
				
		if Input.is_action_pressed(key_speedburst) && isCarryingPuck:
			arrow.visible = true
			if arrow.modulate.a <= 0.2 && input != Vector2.ZERO:
				arrow.rotation = (Vector2.ZERO - input).angle()
			var curRot = arrow.rotation
			if input != Vector2.ZERO:
				arrow.rotation = lerp_angle(curRot, (Vector2.ZERO - input).angle(), 0.02)
		if Input.is_action_just_released(key_speedburst) && isCarryingPuck:
			var puck = $"..".find_child("Puck", true, false)
			puck.find_child("PinJoint2D", true, false).set_node_b("")
			puck.linear_velocity = Vector2.ZERO
			puck.apply_impulse((Vector2(cos(arrow.rotation),sin(arrow.rotation))*-1)*5*burstAmplitude, Vector2(0,0))
			print((Vector2(cos(arrow.rotation),sin(arrow.rotation))*-1)*5*burstAmplitude)
			$"..".find_child("AudioStreamPlayer2D2", true, false).stream = slapshot
			$"..".find_child("AudioStreamPlayer2D2", true, false).play()
			burstAmplitude = 0.2
			arrow.visible = false
			arrow.find_child("TextureProgressBar").value = 0 
		if Input.is_action_just_released(key_speedburst) && burstAvailable && !isCarryingPuck:
			beforeBurstVelocity = state.linear_velocity
			burstAvailable = false
			speedbursting = true
			burstCD.start()
			#speedburst(state, input)
			timer.start()
			#print("speeding")
			$".."/audioplayer3.stream = burstSound
			$".."/audioplayer3.play()
			
			state.apply_impulse((Vector2(cos(arrow.rotation),sin(arrow.rotation))*-1)*torque*burstAmplitude, Vector2(0,0))
			#print(str(arrow.rotation) + " VITTU EI TOIMI")
			#print(burstAmplitude)
			#$ArrowLine.add_point(Vector2.ZERO)
			#$ArrowLine.add_point(Vector2.ZERO + input*50)
			burstAmplitude = 0.2
			arrow.visible = false
			arrow.find_child("TextureProgressBar").value = 0 
			
			#state.linear_velocity = state.linear_velocity.normalized() * max_speed*2
			#state.apply_force(input*torque*4, Vector2(0,0))
			
		if !speedbursting:
			if !(Input.is_action_pressed(key_speedburst) && burstAvailable) && !(Input.is_action_pressed(key_speedburst) && isCarryingPuck):
				
				state.apply_force(input.normalized()*torque, Vector2(0,0))
				if !isCarryingPuck:
					arrow.rotation = (Vector2.ZERO - state.linear_velocity.normalized()*-1).angle()
				else:
					arrow.rotation = (Vector2.ZERO - state.linear_velocity.normalized()).angle()
				#print(arrow.rotation)
		if state.linear_velocity.length()>max_speed && !speedbursting:
			state.linear_velocity=state.linear_velocity.normalized()*max_speed
	else:
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		
		
	if GameManager.GameEnded == true:
		state.transform = Transform2D(0, spawnPosition)
		fadeModulationAlpha = false
		modulate.a = 1
		set_collision_layer_value(1, true)
		arrow.visible = false
		burstAvailable = false
		

	
func respawn():

	pass
	
func toggle_controls(c):
	set_controllable = c
	$LabelScore.text = str(GameManager.Players[playerId].score)
	pass
	

	# GameManager alive players array and set alive status && 
	# on each death see if only one remains -> increment score
func player_death():
	#process_mode = Node.PROCESS_MODE_DISABLED 
	toggle_controls(false)
	#$trail.clear_points()
	#print("kuolin")
	fadeModulationAlpha = true
	#print(fadeModulationAlpha)
	$"..".killPlayer(playerId)
	



	#$"..".game_restart()
# Called when the node enters the scene tree for the first time.
func _ready():
	max_speed = GameManager.maxSpeed
	torque = GameManager.torque
	var physicsMat = PhysicsMaterial.new()
	physicsMat.bounce = GameManager.bounce
	physicsMat.friction = 0
	set_physics_material_override(physicsMat)
	print(get_physics_material_override())
	
	
	
	timer = Timer.new()
	burstCD = Timer.new()
	add_child(burstCD)
	add_child(timer)
	burstCD.wait_time = 3
	burstCD.one_shot = true
	burstCD.connect("timeout", self.burstTimeout)
	timer.wait_time = 0.15
	timer.one_shot = true
	arrow = arrow.instantiate()
	add_child(arrow)
	arrow.visible = false
	arrow.modulate.a = 0

	
	timer.connect("timeout", self.timeout)
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fadeModulationAlpha == true:
		set_collision_layer_value(1, false)
		#print(str(playerId) + " moduloi")
		modulate.a = modulate.a - 1 * delta
	
	if set_controllable == true:
		if Input.is_action_pressed(key_speedburst) && burstAvailable && !isCarryingPuck:
			if burstAmplitude <= 2:
				burstAmplitude = burstAmplitude + 2 * delta
				arrow.find_child("TextureProgressBar").value = ((burstAmplitude - 0.2) / 2) * 115

			if arrow.modulate.a <= 1:
				arrow.modulate.a = arrow.modulate.a + 10 * delta
		
		if Input.is_action_pressed(key_speedburst) && isCarryingPuck:
			if burstAmplitude <= 4:
				burstAmplitude = burstAmplitude + 3 * delta
				arrow.find_child("TextureProgressBar").value = ((burstAmplitude - 0.2) / 4) * 105

			if arrow.modulate.a <= 1:
				arrow.modulate.a = arrow.modulate.a + 10 * delta
			

		if Input.is_action_just_released(key_speedburst):
			
			arrow.modulate.a = 0
			arrow.visible = false
			arrow.find_child("TextureProgressBar").value = 0
	if burstCD.time_left >= 0:
		$PlayerImage.value = (burstCD.time_left / burstCD.wait_time) * 100
	
	pass
	
