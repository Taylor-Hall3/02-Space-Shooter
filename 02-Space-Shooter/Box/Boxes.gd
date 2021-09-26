extends Node2D

var positions = [
	Vector2(100,100)
	,Vector2(1000,150)
	,Vector2(800,600)
	,Vector2(200,550)
]
var Box = preload("res://Box/Box.tscn")
var Unbreakable_Box = preload("res://Box/Unbreakable_Box.tscn")
var count = 0
var target = 1
var respawn = 1500

func _ready():
	randomize()

func _physics_process(_delta):
	if get_child_count() == 0:
		add_box()
	count += 1
	if count > target:
		add_box()

func add_box():
	var box = Box.instance()
	if randf() < 0.6:
		box = Unbreakable_Box.instance()
	box.position = positions[randi() % positions.size()] + Vector2(randf()*100, randf()*100).rotated(randf()*2*PI)
	box.linear_velocity = Vector2(30,0).rotated(randf()*2*PI)
	add_child(box)
	target = randi() % respawn
	count = 0
