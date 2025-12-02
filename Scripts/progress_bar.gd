extends ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
@export var p1 : bool
@export var main: Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(p1):
		value = main.p1Power
	else:
		value = main.p2Power
