extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var coll = move_and_collide(velocity * delta)
	if coll != null:
		var normal = coll.get_normal()
		if normal.x != 0:
			velocity.x = -velocity.x
		else:
			velocity.y = -velocity.y
