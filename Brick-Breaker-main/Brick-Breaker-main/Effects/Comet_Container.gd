extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	for c in get_children():
		c.rect_size *= 0.99
		if c.rect_size.x <1:
			c.queue_free()
