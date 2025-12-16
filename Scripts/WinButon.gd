extends Button

@onready var screenWinText: Label = $"../Player Win"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed(winner: int) -> void:
	screenWinText.text = winCon(winner)
	pass # Replace with function body.
	#iport main scene, then re-set up game

func winCon(winner: int) -> String:
	var text = "Yay! Player "+str(winner)+" Wins!"
	text  = "Yay! Player One Wins!"
	return text #change to Angry Jason or Senor Blanco
