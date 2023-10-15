extends Button
var texture
var error
var http_request
# Called when the node enters the scene tree for the first time.
func _ready():
	# Create an HTTP request node and connect its completion signal.
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	pass # Replace with function body.

func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")
	
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")
		
		
	texture = ImageTexture.create_from_image(image)
	if texture:
		texture.set_size_override(Vector2(115,115))
		$"..".faceSprites.append(texture)
		print($"..".faceSprites)
		
		if $"..".faceSprites.size() > 0:
			$"../PopupMenu".clear()
			var i = 0
			while i < $"..".faceSprites.size():
				$"../PopupMenu".add_icon_item($"..".faceSprites[i], "", i, 0)
				i = i + 1
		


func _on_button_down():
	# Perform the HTTP request.
	error = http_request.request($"../ImageUrl".text)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	
	pass # Replace with function body.
