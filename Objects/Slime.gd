extends CharacterBody2D

var SPEED = 100

func _physics_process(delta):
	
	var ix = Input.get_axis("ui_left","ui_right")
	var iy = Input.get_axis("ui_up","ui_down")
	var iv = Vector2(ix, iy)
	
	var nv = iv.normalized()
	
	velocity = nv * SPEED
	
	move_and_slide()
	



