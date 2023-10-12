extends Control

var numberOfPlayers
var currentlySelecting = 1
var controlSchemes = ["WASD","Arrows","Controller 1","Controller 2","IJKL"]
var playerColors = [Color(0.83,0.57,0.95,1),Color(0.54,0.98,0.6,1),Color(0.27,0.96,0.9,1),Color(0.9,0.26,0.01,0.8)]
var menuTimer
var playerNames = ["Player1","Player2","Player3","Player4"]
var playerImages = [2,1,0,3]
var currentlyEditingControl = 0

#var face1 = preload("res://graphics/faces/01.png")
#var face2 = preload("res://graphics/faces/02.png")
#var face3 = preload("res://graphics/faces/03.png")
#var face4 = preload("res://graphics/faces/04.png")
#var face5 = preload("res://graphics/faces/05.png")
#var faceSprites = [face1, face2, face3, face4, face5]
var faceSprites = []

var playerControlOptions = [0,1,2,3]

func get_faces():
	var files = []
	var dir = DirAccess.open("res://graphics/faces/")
	var index = 1
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			elif file_name == "0" + str(index) + ".png":
				print("Found face: " + file_name)
				index = index +1
				files.append(dir.get_current_dir() + "/" + file_name)
			else:
				print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return files
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	var files = []
	files = get_faces()

	var i = 0
	while i < files.size():
		faceSprites.append(load(str(files[i])))
		i = i + 1
		
	print(faceSprites)
	i = 0
	while i < faceSprites.size():
		$PopupMenu.add_icon_item(faceSprites[i], "", i, 0)
		i = i + 1
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func _on_start_button_down():
	
	if $PlayerCount.is_anything_selected():
		GameManager.populate_Players($PlayerCount.get_item_text($PlayerCount.get_selected_items()[0]))
		GameManager.PlayerNames = playerNames
		GameManager.PlayerControlOptions = playerControlOptions
		GameManager.playerColors = playerColors
		GameManager.playerImages = playerImages
		GameManager.faces = faceSprites
		GameManager.icewallEnabled = $icewallCheckBox.is_pressed()
		var scene = load("res://scenes/levels/level.tscn").instantiate()
		var curScene = get_tree().current_scene
		GameManager.bounce = $VBoxContainer/bounceSlider.value/100
		if $VBoxContainer/maxSpeedText.text:
			GameManager.maxSpeed = int($VBoxContainer/maxSpeedText.text)
		else: 
			GameManager.maxSpeed = 550
		if $VBoxContainer/torqueText.text:
			GameManager.torque = int($VBoxContainer/torqueText.text)
		else: 
			GameManager.torque = 1200
		
		get_tree().root.add_child(scene)
		get_tree().set_current_scene(scene)
		get_tree().root.remove_child(curScene)
	else:
		return
	pass # Replace with function body.


func _on_player_count_item_selected(index):
	numberOfPlayers = int($PlayerCount.get_item_text($PlayerCount.get_selected_items()[0]))
	var playersMax = 4

	for n in numberOfPlayers:
		#print("Button" + str(n+1))
		find_children("Button" + str(n+1), "", true, false)[0].visible = true
		find_children("ColorP" + str(n+1), "", true, false)[0].visible = true
		find_children("ColorP" + str(n+1), "", true, false)[0].color = playerColors[n]
		find_children("Label" + str(n+1), "", true, false)[0].text = controlSchemes[playerControlOptions[n]]
		find_children("Name" + str(n+1), "", true, false)[0].text = playerNames[n]
		find_children("playerImage" + str(n+1), "", true, false)[0].visible = true
		if playerImages[n] < faceSprites.size():
			find_children("playerImage" + str(n+1), "", true, false)[0].set_texture(faceSprites[playerImages[n]])
		else: 
			print("asdasd")
			find_children("playerImage" + str(n+1), "", true, false)[0].set_texture(null)
		
	var hiddenPlayers = numberOfPlayers + 1
	while hiddenPlayers <= playersMax:
		find_children("Button" + str(hiddenPlayers), "", true, false)[0].visible = false
		find_children("ColorP" + str(hiddenPlayers), "", true, false)[0].visible = false
		find_children("playerImage" + str(hiddenPlayers), "", true, false)[0].visible = false
		hiddenPlayers = hiddenPlayers + 1
	pass # Replace with function body.


func openControllerSelection(player):
	$PlayerName.visible = true
	$ButtonFace.visible = true
	$PlayerName.text = playerNames[player-1]
	$ItemList.visible = true
	$ColorPickerButton.visible = true
	currentlySelecting = player
	$ItemList.select(playerControlOptions[player-1])
	$ColorPickerButton.color = playerColors[currentlySelecting-1]

	pass
	
func _on_item_list_item_selected(index):	
	playerControlOptions[currentlySelecting-1] = $ItemList.get_selected_items()[0]
	find_children("Label" + str(currentlySelecting), "", true, false)[0].text = controlSchemes[playerControlOptions[currentlySelecting-1]]
	print($ItemList.get_item_text($ItemList.get_selected_items()[0]))
	
	pass # Replace with function body.

func _on_button_1_button_down():
	openControllerSelection(1)
	pass # Replace with function body.

func _on_button_2_button_down():
	openControllerSelection(2)
	pass # Replace with function body.


func _on_button_3_button_down():
	openControllerSelection(3)
	pass # Replace with function body.


func _on_button_4_button_down():
	openControllerSelection(4)
	pass # Replace with function body.


func _on_color_picker_button_color_changed(color):
	playerColors[currentlySelecting-1] = $ColorPickerButton.color
	find_children("ColorP" + str(currentlySelecting), "", true, false)[0].color = playerColors[currentlySelecting-1]
	pass # Replace with function body.


func _on_player_name_text_changed(new_text):
	playerNames[currentlySelecting-1] = $PlayerName.text
	find_children("Name" + str(currentlySelecting), "", true, false)[0].text = playerNames[currentlySelecting-1]
	pass # Replace with function body.


func _on_button_face_button_down():
	$PopupMenu.popup()
	pass # Replace with function body.


func _on_popup_menu_id_pressed(id):
	playerImages[currentlySelecting-1] = id
	if id < faceSprites.size():
		find_children("playerImage" + str(currentlySelecting), "", true, false)[0].set_texture(faceSprites[playerImages[currentlySelecting-1]])
	else:
		find_children("playerImage" + str(currentlySelecting), "", true, false)[0].set_texture(null)
		
	pass # Replace with function body.


func _on_edit_controls_button_button_down():
	if $EditControlsPanel.visible == true:
		$EditControlsPanel.visible = false
	else:
		$EditControlsPanel.visible = true
	pass # Replace with function body.


func _on_edit_controls_list_item_selected(index):
	currentlyEditingControl = $EditControlsPanel/HBoxContainer2/EditControlsList.get_selected_items()[0]
	pass # Replace with function body.
