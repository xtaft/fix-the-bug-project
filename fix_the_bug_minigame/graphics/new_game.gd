extends Control
signal new_game
@export var first_game = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$ReplayGame.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_button_input_event(_viewport, event, _shape_idx):
	if  event is InputEventScreenTouch:
		if first_game:
			first_game = false
			$FirtstGame.hide()
			$ReplayGame.show()
		if  event is InputEventScreenTouch:
			new_game.emit()
