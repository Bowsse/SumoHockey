extends Node2D

var timer
var timerDraw
var drawT
var lastWinnerText = ""
var lastRoundWinner
var lastRoundDraw

var imageSize
var faceSize
var colliderSize
var hitAreaSize
var scoreTextSize
var initMass
var initTorque

# Called when the node enters the scene tree for the first time.

func killPlayer(id):
	GameManager.AlivePlayers[id] = 0
	var lastAlive
	var a = 0
	var i = 0
	while i < GameManager.AlivePlayers.size():
		if GameManager.AlivePlayers[i] == 1:
			a = a + 1
			lastAlive = i
		i = i + 1
	
	i = 0
	if a == 1:
		lastRoundWinner = lastAlive
		lastRoundDraw = false
		#lastWinnerText = "Winner: " + str(GameManager.Players[lastAlive].id)
		#GameManager.GameEnded = true
		drawT.start()
	elif a == 0:
		lastRoundDraw = true
		pass
	
		
	pass
func drawTimeout():
	if !lastRoundDraw:
		GameManager.Players[lastRoundWinner].score = GameManager.Players[lastRoundWinner].score + 1
		lastWinnerText = str(GameManager.PlayerNames[lastRoundWinner]) + " wins"
	else: 
		lastWinnerText = "Draw"
	GameManager.GameEnded = true
	var i = 0
	while i < GameManager.AlivePlayers.size():
			GameManager.AlivePlayers[i] = 1
			i = i + 1
	game_restart()
	pass

func game_restart():

	$PowerUpSpawner.reset_powerups()
	GameManager.GameEnded = true
	timer.start()
	$Puck.linear_velocity = Vector2.ZERO
	$Puck.find_child("PinJoint2D", true, false).node_b = ""
	$Puck.position = $center.position
	$Puck.PROCESS_MODE_DISABLED
	for p in GameManager.Players:
		var playernode = find_children("player"+str(p.id), "", true, false)
		#print(playernode)
		playernode[0].toggle_controls(false)
		#playernode[0].respawn()
		playernode[0].process_mode = Node.PROCESS_MODE_INHERIT
		playernode[0].burstAvailable = false
		
		playernode[0].find_child("PlayerImage", true, false).scale = imageSize
		playernode[0].find_child("FaceSprite", true, false).scale = faceSize
		playernode[0].find_child("CollisionShape2D", true, false).scale= colliderSize
		playernode[0].find_child("HitCollisionShape2D", true, false).scale = hitAreaSize
		playernode[0].find_child("LabelScore", true, false).scale = scoreTextSize
		playernode[0].mass = initMass
		playernode[0].torque = initTorque
		#playernode[0].set_position(playernode[0].spawnPosition)
		
		
	#$scorelabel.text = lastWinnerText
	#$PopupPanel.show()
	#PopupPanel.position.y = $PopupPanel.position.y + 80
	#$PopupPanel/PlayButton.grab_focus()
	#get_tree().paused = true
	
	
	
func timeout():
	#print("timer")
	GameManager.GameEnded = false
	$Puck.PROCESS_MODE_INHERIT
	for p in GameManager.Players:
		var playernode = find_children("player"+str(p.id), "", true, false)
		#print(playernode)
		playernode[0].toggle_controls(true)
		#playernode[0].burstCD.start()
		playernode[0].burstAvailable = true
	lastWinnerText = ""
	
	
func _ready():
	for p in GameManager.Players:
		var player = load("res://scenes/packed_nodes/playerHockey.tscn")
		var player_instance = player.instantiate()
		player_instance.set_name("player" + str(p.id))
		add_child(player_instance)
		var spawnPositions = find_children("spawnlocations" + str(GameManager.Players.size()), "", true, false)
		var spawnpos = spawnPositions[0].get_child(int(p.id)-1)
		player_instance.set_position(spawnpos.position)
		player_instance.playerId = p.id
		imageSize = player_instance.find_child("PlayerImage", true, false).scale
		faceSize = player_instance.find_child("FaceSprite", true, false).scale
		colliderSize = player_instance.find_child("CollisionShape2D", true, false).scale
		hitAreaSize = player_instance.find_child("HitCollisionShape2D", true, false).scale
		scoreTextSize = player_instance.find_child("LabelScore", true, false).scale
		initMass = player_instance.mass
		initTorque = player_instance.torque
		

		player_instance.spawnPosition = spawnpos.position
		player_instance.key_left = "left" + str(GameManager.PlayerControlOptions[p.id])
		player_instance.key_right = "right" + str(GameManager.PlayerControlOptions[p.id])
		player_instance.key_down = "down" + str(GameManager.PlayerControlOptions[p.id])
		player_instance.key_up = "up" + str(GameManager.PlayerControlOptions[p.id])
		player_instance.key_speedburst = "speedburst" + str(GameManager.PlayerControlOptions[p.id])
		
		player_instance.find_children("PlayerImage")[0].set_modulate(Color(GameManager.playerColors[p.id]))
		player_instance.find_children("trail")[0].default_color = Color(GameManager.playerColors[p.id])
		if GameManager.playerImages[p.id] < GameManager.faces.size():	
			player_instance.find_children("FaceSprite")[0].set_texture(GameManager.faces[GameManager.playerImages[p.id]])
			player_instance.find_children("LabelScore")[0].modulate.a = 0.5
			
	timer = Timer.new()
	
	add_child(timer)
	timer.wait_time = 4.0
	timer.one_shot = true
	
	timer.connect("timeout", self.timeout)
	
	drawT = Timer.new()
	
	add_child(drawT)
	drawT.wait_time = 1.0
	drawT.one_shot = true
	
	drawT.connect("timeout", self.drawTimeout)

	#print(timer.time_left)
	
	timer.start()
	for p in GameManager.Players:
		var playernode = find_children("player"+str(p.id), "", true, false)
		#print(playernode)
		playernode[0].toggle_controls(false)
		#playernode[0].toggle_controls(false)


func _process(_delta):
	if Input.is_action_pressed("key_exit"):
		var scene = load("res://scenes/levels/main_menu.tscn").instantiate()
		var curScene = get_tree().current_scene
		print("current scene: " + str(curScene))
		get_tree().paused = true
		get_tree().root.add_child(scene)
		get_tree().set_current_scene(scene)
		
		var removePlayers = find_children("player*", "", true, false)
		var  i = 0
		while i < removePlayers.size():
			remove_child(removePlayers[i])
			i = i + 1
		
		var removeField = find_children("Field", "", true, false)
		i = 0
		while i < removeField.size():
			remove_child(removeField[i])
			i = i + 1
		
		GameManager.Players = []
		GameManager.GameEnded = false
		GameManager.PlayerControlOptions = []
		GameManager.playerColors = []
		GameManager.PlayerNames = []
		GameManager.playerImages = []
		GameManager.faces = []
		GameManager.AlivePlayers = []
		
		get_tree().root.remove_child(curScene)
	pass




func _on_play_button_button_down():
	#print("popup play")
	$PopupPanel.hide()
	get_tree().paused = false
	pass # Replace with function body.


func _on_popup_panel_popup_hide():
	get_tree().paused = false
	pass # Replace with function body.
