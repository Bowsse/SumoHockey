extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_down():
	$"../FileDialog".popup()
	pass # Replace with function body.


func _on_file_dialog_files_selected(paths):
	for path in paths.size():
		var image = Image.new()
		image.load(paths[path])
		var texture = ImageTexture.create_from_image(image)
		if texture:
			texture.set_size_override(Vector2(115,115))
			$"..".faceSprites.append(texture)
			if $"..".faceSprites.size() > 0:
				$"../PopupMenu".clear()
				var i = 0
				while i < $"..".faceSprites.size():
					$"../PopupMenu".add_icon_item($"..".faceSprites[i], "", i, 0)
					i = i + 1
	pass # Replace with function body.
