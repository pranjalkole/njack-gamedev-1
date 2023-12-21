extends CanvasLayer
signal start_game
signal end_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var score = 0
func _on_start_pressed():
	$VBoxContainer.hide()
	$Label.text = "Score: " + str(score)
	emit_signal("start_game")


func _on_player_score_incr():
	score += 10
	$Label.text = "Score: " + str(score)
var instance

func _on_button_pressed():
	score = 0
	instance.queue_free()
	$Label.text = "Score: 0"
	$Label.show()
	start_game.emit()

var over_scene = preload("res://gameover.tscn")
func _on_player_gameover():
	var scorefile = FileAccess.open("user://score", FileAccess.WRITE)
	scorefile.store_line(JSON.stringify({"score": score}))
	emit_signal("end_game")
	$Label.hide()
	instance = over_scene.instantiate()
	instance.get_node("Button").connect("pressed", _on_button_pressed)
	instance.get_node("Score").text = "Score: " + str(score)
	add_child(instance)
