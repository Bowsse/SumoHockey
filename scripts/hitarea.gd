extends Area2D

var hitsound = preload("res://audio/hitsound.mp3")
var wallsound = preload("res://audio/icebreaking.mp3")
func _on_body_entered(body):
	
	match body.get_groups():
		["players"]:
			$".."/".."/audioplayer.stream = hitsound
			$".."/".."/audioplayer.play()
			#print($".."/".."/audioplayer.stream)
		["walls"]:
			$".."/".."/audioplayer2.stream = wallsound
			$".."/".."/audioplayer2.play()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
