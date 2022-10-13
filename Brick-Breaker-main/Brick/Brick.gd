extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false

var powerup_prob = 0.1

func _ready():
	randomize()
	position = new_position
	if score >= 100:
		$ColorRect.color = Color8(224,49,49)
	elif score >= 90:
		$ColorRect.color = Color8(225,146,43)
	elif score >= 80:
		$ColorRect.color = Color8(255,212,59)
	elif score >= 70:
		$ColorRect.color = Color8(148,216,45)
	elif score >= 60:
		$ColorRect.color = Color8(34,139,230)
	elif score >= 50:
		$ColorRect.color = Color8(132,94,247)
	elif score >= 40:
		$ColorRect.color = Color8(190,75,219)
	else:
		$ColorRect.color =Color8(134,142,150)

func _physics_process(_delta):
	if dying and not $Confetti.emitting:
		queue_free()

func hit(_ball):
	var Brick_sound = get_node_or_null("/root/Game/Brick_Sound")
	if Brick_sound != null:
		Brick_sound.play()
	die()

func die():
	$Confetti.emitting = true
	dying = true
	collision_layer = 0
	$ColorRect.hide()
	Global.update_score(score)
	if not Global.feverish:
		Global.update_fever(score)
	get_parent().check_level()
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instance()
			powerup.position = position
