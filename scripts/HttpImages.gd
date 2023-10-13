extends Node2D

var textures = []
var i
var error
var http_request
# Called when the node enters the scene tree for the first time.
func _ready():
	# Create an HTTP request node and connect its completion signal.
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	
	pass # Replace with function body.

func req():
	error = http_request.request("https://raw.githubusercontent.com/Bowsse/SumoHockey/main/graphics/faces/0" + str(i) + ".png")
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	else:
		i = i + 1

func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")
	
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")
		populate_faces()
	else:
		req()
		
	var texture = ImageTexture.create_from_image(image)

	if texture:
		textures.append(texture)
	#print(textures)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func populate_faces():
	if textures.size() > 0:
		$"..".faceSprites = textures
		$"../PopupMenu".clear()
		i = 0
		while i < $"..".faceSprites.size():
			$"../PopupMenu".add_icon_item($"..".faceSprites[i], "", i, 0)
			i = i + 1
	print($"..".faceSprites)

func _on_load_images_from_web_button_button_down():
	
	textures = []
	i = 1
	# Perform the HTTP request.
	error = http_request.request("https://raw.githubusercontent.com/Bowsse/SumoHockey/main/graphics/faces/0" + str(i) + ".png")
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	else:
		i = i + 1
	pass # Replace with function body.
