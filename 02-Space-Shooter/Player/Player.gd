extends KinematicBody2D

var VP := Vector2.ZERO
var velocity := Vector2.ZERO
var acceleration := 0.4
var max_speed := 10

var push := 400
var reflect := 2

var Bullet = preload("res://Bullet/Bullet.tscn")
var Bullets = null

var Explosion = preload("res://Explosion/Explosion_ship.tscn")
var Explosions = null

func _ready():
	VP = get_viewport().size

func _physics_process(_delta):
	position.x = wrapf(position.x,0,VP.x)
	position.y = wrapf(position.y,0,VP.y)
	var pos = get_viewport().get_mouse_position()
	look_at(pos)
	rotation_degrees += 90

	velocity += get_input()*acceleration
	velocity = velocity.normalized() * clamp(velocity.length(),0,max_speed)
	var collision = move_and_collide(velocity,false)
	if collision != null and collision.collider is RigidBody2D:
		collision.collider.apply_central_impulse(-collision.normal * push)
		velocity = velocity + collision.normal*reflect
		if collision.collider.has_method("die"):
			collision.collider.die()
		die()
	elif collision != null:
		die()

	if Input.is_action_just_pressed("shoot"):
		if Bullets == null:
			Bullets = get_node_or_null("/root/Game/Bullets")
		if Bullets != null:
			var bullet = Bullet.instance()
			bullet.position = position + Vector2(0,-20).rotated(rotation)
			bullet.rotation = rotation
			Bullets.add_child(bullet)

func die():
	if Global.has_method("update_health"):
		Global.update_health(-10)
	if Explosions == null:
		Explosions = get_node_or_null("/root/Game/Explosions")
	if Explosions != null:
		var explosion = Explosion.instance()
		explosion.position = position
		Explosions.add_child(explosion)
	queue_free()

func get_input():
	var input_dir = Vector2(0,0)
	if Input.is_action_pressed("forward"):
		input_dir.y -= 1
	if Input.is_action_pressed("back"):
		input_dir.y += 1
	if Input.is_action_pressed("left"):
		input_dir.x -= 1
	if Input.is_action_pressed("right"):
		input_dir.x += 1
	return input_dir.rotated(rotation)
	return Vector2.ZERO
