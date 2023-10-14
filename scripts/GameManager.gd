extends Node

var Players = []
var AlivePlayers = []
var GameEnded = false
var PlayerControlOptions = []
var playerColors = []
var PlayerNames = []
var playerImages = []
var faces = []
var icewallEnabled
var bounce
var maxSpeed
var torque
var burstImpulse
var burstTime
var powerups
var burstCD
var trailLength

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.



func populate_Players(selection):
	for i in int(selection):
		Players.append({
			"id" : 	i,
			"score" : 0,
		})
		AlivePlayers.append(1)
		i = i+1	

	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
