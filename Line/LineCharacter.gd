extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite = $Sprite2D
@onready var trajectoryLine
var myDirection = "right"

func _ready():
	var lineScene = preload("res://TrajectoryLine.tscn")
	trajectoryLine = lineScene.instantiate()
	get_tree().root.get_node("Node2D").add_child.call_deferred(trajectoryLine)

func _physics_process(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		
		if direction == -1:
			myDirection = "right"
			sprite.flip_h = false
		elif direction == 1:
			myDirection = "left"
			sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	if Input.is_action_just_released("space"):
		trajectoryLine._update_trajectory(myDirection, JUMP_VELOCITY, get_gravity().y, delta, SPEED, position)
