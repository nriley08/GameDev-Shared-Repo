extends Node2D
const SPEED = 300.0
const JUMP_VELOCITY = -6.5
@onready var sprite = $Sprite2D
@onready var trajectoryLine
var myDirection = "right"
@onready var progressBar: ProgressBar = $ProgressBar

func _ready():
	var lineScene = preload("res://Line/TrajectoryLine.tscn")
	trajectoryLine = lineScene.instantiate()
	add_child.call_deferred(trajectoryLine)

func _physics_process(delta: float) -> void:


	if Input.is_action_pressed("p1shoot"):
		trajectoryLine._update_trajectory("right", 9.8, delta, Vector2(0,0), progressBar.value)
		#print("h")
	elif Input.is_action_just_released("p1shoot"):
		trajectoryLine._refresh()
