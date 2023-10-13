extends Node2D
var poweringUp = false
var poweringBody
var image
var face
var colli
var hit
var score
var imageInitScale

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.modulate.a = 0
	$StaticBody2D/Sprite2D.modulate.a = 0
	$StaticBody2D/Sprite2D.scale = Vector2(10,10)

	
	pass # Replace with function body.

func timeout():
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Sprite2D.modulate.a < 1:
		$Sprite2D.modulate.a = $Sprite2D.modulate.a + lerp($Sprite2D.modulate.a, 1.0, 1)*0.2 * delta
	if $Sprite2D.scale.x > 0.06:
		$Sprite2D.scale.x = $Sprite2D.scale.x - lerp(0.06, $Sprite2D.scale.x, 1)*0.3 * delta
		$Sprite2D.scale.y = $Sprite2D.scale.y - lerp(0.06,$Sprite2D.scale.y, 1)*0.3 * delta
	
	if $Sprite2D.scale.x <= 0.06:
		if $StaticBody2D/Sprite2D.modulate.a < 1:
			$StaticBody2D/Sprite2D.modulate.a = $StaticBody2D/Sprite2D.modulate.a + 3 * delta
			$StaticBody2D/Sprite2D.modulate.r = $StaticBody2D/Sprite2D.modulate.r + 3 * delta
			$StaticBody2D/Sprite2D.modulate.g = $StaticBody2D/Sprite2D.modulate.g + 3 * delta
			$StaticBody2D/Sprite2D.modulate.b = $StaticBody2D/Sprite2D.modulate.b + 3 * delta
		if $StaticBody2D/Sprite2D.modulate.a > 1:
			$StaticBody2D/Sprite2D.modulate.a = 1
			$StaticBody2D/Sprite2D.modulate.r = 1
			$StaticBody2D/Sprite2D.modulate.g = 1
			$StaticBody2D/Sprite2D.modulate.b = 1
			
		if $StaticBody2D/Sprite2D.scale > Vector2(0.3,0.3):
			$StaticBody2D/Sprite2D.scale = $StaticBody2D/Sprite2D.scale - Vector2(50, 50) * delta
		if $StaticBody2D/Sprite2D.scale < Vector2(0.3,0.3):
			$StaticBody2D/Sprite2D.scale = Vector2(0.3,0.3)
			
	if $StaticBody2D/Sprite2D.scale.x <= 0.5 && !poweringUp:
		$Area2D.set_collision_layer_value(1, true)
		$Area2D.set_collision_mask_value(1, true)
		
	if poweringUp:
		
		if image.scale < imageInitScale*1.5:
			image.scale = image.scale + image.scale/100 * delta*100
			face.scale = face.scale + face.scale/100 * delta*100
			colli.scale = colli.scale + colli.scale/100 * delta*100
			hit.scale = hit.scale + hit.scale/100 * delta*100
			score.scale = score.scale + score.scale/100 * delta*100
			poweringBody.mass = poweringBody.mass + poweringBody.mass/100 * delta * 100
			poweringBody.torque = poweringBody.torque + poweringBody.torque/100 * delta * 100
		else:
			get_parent().remove_child(self)
			queue_free()
		
	pass


func _on_area_2d_body_entered(body):
	print(body)
	if body.get_groups().has("players"):
		if !body.poweredUp:
			poweringBody = body
			image = body.find_child("PlayerImage", true, false)
			face = body.find_child("FaceSprite", true, false)
			colli = body.find_child("CollisionShape2D", true, false)
			hit = body.find_child("HitCollisionShape2D", true, false)
			score = body.find_child("LabelScore", true, false)
			imageInitScale = image.scale
			poweringUp = true
			visible = false
			$Area2D.set_collision_layer_value(1, false)
			$Area2D.set_collision_mask_value(1, false)
			body.poweredUp = true
		
		#visible = false
		
		
	pass # Replace with function body.
