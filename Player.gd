extends KinematicBody2D

const UP = Vector2(0, -1)
const SPEED = 500
const JUMPFORCE = -600
const GRAVITY = 25
var vel = Vector2()

func _physics_process(delta):
	vel.y += GRAVITY
	if Input.is_action_pressed("ui_right"):
		vel.x = SPEED
	elif Input.is_action_pressed("ui_left"):
		vel.x = -SPEED
	else:
		vel.x = 0
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			vel.y = JUMPFORCE
	vel = move_and_slide(vel, UP)
