extends Line2D

@export var maxPoints = 70
@onready var testCollision = $TestObject
var collision
var linePosition = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_refresh()

func _refresh():
	clear_points()
	linePosition = get_parent().get_node("CharacterBody2D").position
	testCollision.velocity = Vector2.ZERO
	
	for i in maxPoints:
		add_point(linePosition)
	testCollision.position = linePosition
	collision = null
	visible = false
	
	
func _update_trajectory(direction, jumpForce, gravity, delta, characterXVelocity, startingPosition):
	linePosition = startingPosition
	testCollision.position = linePosition
	testCollision.velocity.y = jumpForce
	
	if direction == "right":
		testCollision.velocity.x = -characterXVelocity
	else:
		testCollision.velocity.x = characterXVelocity
	
	for i in get_point_count():
		if !collision:
			testCollision.velocity.y += gravity * delta
		set_point_position(i, testCollision.position)
		collision = testCollision.move_and_collide(testCollision.velocity * delta, false)
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
