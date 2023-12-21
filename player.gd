extends CharacterBody2D
signal score_incr
signal gameover
var speed=400
var screen_size
var start

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = DisplayServer.window_get_size() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
var run_speed = 350
var jump_speed = -800
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_up')

	if is_on_floor() and jump:
		velocity.y = jump_speed
	if right:
		velocity.x += run_speed
	if left:
		velocity.x -= run_speed
	if velocity.x:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
var scene = preload("res://stars.tscn")
var instance
var counter
func _physics_process(delta):
	velocity.y += gravity * delta
	get_input()
	if start: move_and_slide()


func _on_canvas_layer_start_game():
	counter = 0
	var instance = scene.instantiate()
	add_sibling(instance)
	show()
	start = true


func _on_area_2d_body_entered(body):
	body.queue_free()
	emit_signal("score_incr")
	counter += 1
	if (counter == 10):
		counter = 0
		body.get_parent().queue_free()
		instance = scene.instantiate()
		call_deferred("add_sibling", instance)
		var bombbody = CharacterBody2D.new()
		bombbody.set_collision_layer_value(1, false)
		bombbody.set_collision_layer_value(3, true)
		bombbody.set_collision_mask_value(1, false)
		bombbody.set_collision_mask_value(3, true)
		bombbody.set_velocity(Vector2(50, 50))
		bombbody.position = Vector2(50,50)
		bombbody.set_script(load("res://bomb.gd"))
		var spr = ColorRect.new()
		spr.position = Vector2(-4, -4)
		spr.size = Vector2(8, 8)
		var col2d = CollisionShape2D.new()
		var shp = RectangleShape2D.new()
		shp.size = Vector2(8, 8)
		col2d.set_shape(shp)
		bombbody.add_child(spr)
		bombbody.add_child(col2d)
		$"../Bomb".call_deferred("add_child", bombbody)


func _on_area_2d_2_body_entered(body):
	emit_signal("gameover")

func _on_canvas_layer_end_game():
	start = false
	instance.queue_free()
	for child in $"../Bomb".get_children():
		child.queue_free()
	hide()
