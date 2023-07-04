extends CharacterBody2D

var SPEED = 100

func _physics_process(delta):
	var iv = Vector2(
		Input.get_axis("ui_left","ui_right"),
		Input.get_axis("ui_up","ui_down")
		)
	
	var nv = iv.normalized()
	
	velocity = lerp(velocity, nv * SPEED, 0.2)
	
	move_and_slide()




