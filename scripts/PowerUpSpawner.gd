extends Node2D
var powerup = preload("res://scenes/packed_nodes/powerup.tscn")
var timer
var minTime = 5
var maxTime = 10
var radius
var theta
var r
var x
var y
var spawnedPowerups = []

@export var centerPosObject: Node2D
var radiusObject: Node2D

func reset_powerups():
	spawnedPowerups = find_children("powerup*", "", true, false)
	print(spawnedPowerups)
	for i in range(0, spawnedPowerups.size()):
		remove_child(spawnedPowerups[i])
		spawnedPowerups[i].queue_free()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	if GameManager.powerups:
		radiusObject = centerPosObject.find_child("CollisionShape2D", true, false)
		
		timer = Timer.new()
		add_child(timer)
		
		timer.wait_time = randf_range(minTime, maxTime)
		timer.one_shot = true
		
		timer.connect("timeout", self.timeout)
		timer.start()
	pass # Replace with function body.

func timeout():
	radius = radiusObject.shape.radius * centerPosObject.scale.x	
	r = radius * sqrt(randf())
	theta = randf() * 2 * PI
	x = centerPosObject.position.x + r * cos(theta)
	y = centerPosObject.position.y + r * sin(theta)
	var p = powerup.instantiate()
	p.set_name("powerup" + str(x) + str(y))
	p.position.x = x
	p.position.y = y
	p.rotation_degrees = randi() % 360
	add_child(p)
	timer.wait_time = randf_range(minTime, maxTime)
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
