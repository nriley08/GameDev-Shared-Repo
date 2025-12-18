extends Node2D
const SPEED = 300.0
const JUMP_VELOCITY = -6.5
@onready var sprite = $Sprite2D
@onready var trajectoryLine
var myDirection = "left"
@onready var progressBar: ProgressBar = $ProgressBar2

func _ready():
	var lineScene = preload("res://Line/TrajectoryLine.tscn")
	trajectoryLine = lineScene.instantiate()
	add_child.call_deferred(trajectoryLine)

func _physics_process(delta: float) -> void:


	if Input.is_action_pressed("p2shoot"):
		trajectoryLine._update_trajectory("left", 9.8, delta, Vector2(0,0), progressBar.value)
	elif Input.is_action_just_released("p2shoot"):
		trajectoryLine._refresh()
