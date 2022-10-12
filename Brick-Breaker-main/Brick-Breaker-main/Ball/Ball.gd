extends RigidBody2D

var min_speed = 100.0
var max_speed = 600.0
var speed_multiplier = 1.0
var accelerate = false
var decay = 0.04
var released = true
var time_highlight = 0.4
var time_highlight_size = 0.3
var initial_velocity = Vector2.ZERO

var wobble_period = 0.0
var wobble_amplitude = 0.0
export var wobble_max = 5
var wobble_direction = Vector2.ZERO
var decay_wobble = 0.15

export var distort_effect = 0.0002

func _ready():
	contact_monitor = true
	contacts_reported = 8
	if Global.level < 0 or Global.level >= len(Levels.levels):
		Global.end_game(true)
	else:
		var level = Levels.levels[Global.level]
		min_speed *= level["multiplier"]
		max_speed *= level["multiplier"]
	

func _on_Ball_body_entered(body):
	if body.has_method("hit"):
		body.hit(self)
		accelerate = true	
	$Highlight.modulate.a = 1.0
	$Tween.interpolate_property($Images/Highlight, "modulate:a", 1.0, 0.0, time_highlight, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Images/Highlight, "scale", Vector2(2.0,2.0), Vector2(1.0,1.0), time_highlight_size, Tween.TRANS_BOUNCE, Tween.EASE_IN)
	$Tween.start()
	wobble_direction = linear_velocity.tangent().normalized()
	wobble_amplitude = wobble_max

func _input(event):
	if not released and event.is_action_pressed("release"):
		apply_central_impulse(initial_velocity)
		released = true

func _integrate_forces(state):
	if not released:
		var paddle = get_node_or_null("/root/Game/Paddle_Container/Paddle")
		if paddle != null:
			state.transform.origin = Vector2(paddle.position.x + paddle.width, paddle.position.y - 30)	
	if $Highlight.modulate.a > 0:
		$Highlight.modulate.a -= decay
	if position.y > Global.VP.y + 100:
		die()
	if accelerate:
		state.linear_velocity = state.linear_velocity * 1.1
		accelerate = false
	if abs(state.linear_velocity.x) < min_speed * speed_multiplier:
		state.linear_velocity.x = sign(state.linear_velocity.x) * min_speed * speed_multiplier
	if abs(state.linear_velocity.y) < min_speed * speed_multiplier:
		state.linear_velocity.y = sign(state.linear_velocity.y) * min_speed * speed_multiplier
	if state.linear_velocity.length() > max_speed * speed_multiplier:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed * speed_multiplier
		
	#var Comet_Container = get_node_or_null("/root/Game/Comet_Container")
	#if Comet_Container != null:
	#	var c = $Highlight.duplicate()
	#	c.rect_position= global_position
	#	Comet_Container.add_child(c)
		

func change_size(s):
	$Highlight.rect_scale = s
	$CollisionShape2D.scale = s

func change_speed(s):
	speed_multiplier = s

func die():
	queue_free()
	
func wobble():
	wobble_period += 1
	if wobble_amplitude > 0:
		var pos = wobble_direction * wobble_amplitude * sin(wobble_period)
		$Images.position = pos
		wobble_amplitude -= decay_wobble
	
func distort():
	var direction = Vector2( 1+ linear_velocity.length()* distort_effect, 1- linear_velocity.length()*distort_effect)
	$Images.rotation - linear_velocity.angle()
	$Images.scale = direction
