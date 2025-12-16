extends Line2D

var maxPoints = 67
@onready var testCollision = $TestObject
var collision
var linePosition = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_refresh()

func _refresh():
	clear_points()
	linePosition = get_parent().position
	
	for i in maxPoints:
		add_point(linePosition)
	testCollision.position = linePosition
	collision = null
	visible = true
	
	
func _update_trajectory(direction, gravity, delta, startingPosition, power):
	linePosition = startingPosition
	testCollision.position = linePosition
	
	var xMove
	var yMove = -1
	if direction == "right":
		xMove = .55
	else:
		xMove = -.55
	
	for i in get_point_count():
		set_point_position(i, testCollision.position)
		testCollision.position += Vector2(xMove,yMove) * power / 9
		yMove += abs(gravity * delta / 10)
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
