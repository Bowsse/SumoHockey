extends RigidBody2D
var timer
var modulating = false
var fading = false
var numberOfHits = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	
	add_child(timer)
	timer.wait_time = 1.0
	timer.one_shot = true
	
	timer.connect("timeout", self.timeout)
	pass # Replace with function body.

func timeout():
	#process_mode = Node.PROCESS_MODE_DISABLED
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if modulating && modulate.a > 0.5:
		modulate.a = modulate.a - 2 * delta
		
	if fading && modulate.a > 0:
		modulate.a = modulate.a -5 * delta
	if modulate.a <= 0:
		process_mode = Node.PROCESS_MODE_DISABLED
	pass


func _on_body_entered(body):
	timer.start()
	print(body)
	numberOfHits = numberOfHits + 1
	if numberOfHits == 1:
		modulating = true
	elif numberOfHits > 1:
		fading = true
	pass # Replace with function body.


