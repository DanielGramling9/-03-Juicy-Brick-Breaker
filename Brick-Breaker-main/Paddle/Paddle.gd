extends KinematicBody2D

var target = Vector2.ZERO
export var speed = 10.0
var width = 0
var width_default = 0
var decay = 0.02

func _ready():
	width = $CollisionShape2D.get_shape().get_extents().x
	width_default = width
	target = Vector2(Global.VP.x / 2, Global.VP.y - 80)

func _physics_process(_delta):
	target.x = clamp(target.x, 0, Global.VP.x - 2*width)
	position = target
	for c in $Powerups.get_children():
		c.payload()
	if $Highlight.modulate.a > 0:
		$Highlight.modulate.a -= decay

func _input(event):
	if event is InputEventMouseMotion:
		target.x += event.relative.x

func hit(_ball):
	#$Tween.interpolate_property($Sprite, "Get_Rect(0,y)", 30,0,0,Tween.TRANS_BOUNCE,Tween.EASE_IN)
	#$Tween.start()
	#$Confetti.emitting = true
	#$Highlight.modulate.a = 1.0
	var paddle_sound = get_node_or_null("/root/Game/Paddle_Sound")
	if paddle_sound != null:
		paddle_sound.play()
	pass

func powerup(payload):
	for c in $Powerups.get_children():
		if c.type == payload.type:
			c.queue_free()
	$Powerups.call_deferred("add_child", payload)
