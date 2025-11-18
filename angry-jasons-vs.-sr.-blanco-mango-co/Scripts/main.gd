extends Node2D

@onready var p_1_slingshot: AnimatedSprite2D = $P1Slingshot

@onready var camera_2d: Camera2D = $Camera2D
@export var box : PackedScene
@export var bird : PackedScene
@onready var p1MoneyLabel: Label = $CanvasLayer/P1MoneyLabel
var p1 : Player
var p2 : Player
var i = 0
var damageable
@export var birdHolder : BirdInfo

@onready var shop: Node2D = $Shop
@onready var p_1_placement: Button = $P1Placement
@onready var p_2_placement: Button = $P2Placement

const BOX_1 = preload("res://Resources/box1.tres")
var BOX = BOX_1
const BOX_2 = preload("res://Resources/box2.tres")
const BOX_3 = preload("res://Resources/box3.tres")

@onready var p_1_ready: Button = $P1Ready
@onready var p_2_ready: Button = $P2Ready

var p1Ready := false
var p2Ready := false
var p1Boxes : Array[Box]
var p2Boxes : Array[Box]

var p1Direction := 1
var p1Power : float
@export var powerMax : float
@export var increaseValue : float

func _ready() -> void:
	p1 = Player.new()
	p1.init()
	for i in range(0,210):
		p1.addBird(birdHolder)
	print(len(p1.birds))
	p2 = Player.new()
	p2.init()
	p1MoneyLabel.text = p1.getMoney()
	buildStage1()
	p1Power = 1

func _process(_delta):
	#
	if(damageable):
		if(Input.is_action_pressed("p1shoot")):
			showPlayer1Buttons(true)
			p1Power += increaseValue * p1Direction
			if(p1Power > powerMax):
				p1Power = powerMax
				p1Direction = -1
			elif(p1Power < 1):
				p1Power = 1
				p1Direction = 1
		elif(p1Power != 1):
			showPlayer1Buttons(false)
			p1Shoot()
			p1Power = 1
			p1Direction = 1

func p1Shoot():
	var newBirdInfo = p1.getBird()
	if(newBirdInfo == null):
		print("h")
		return
	else:
		var newBird = bird.instantiate()
		newBird.setUp(newBirdInfo)
		newBird.position = p_1_slingshot.position
		newBird.apply_central_impulse(Vector2(1,-1) * p1Power * 10)
		add_child(newBird)

func buildStage1():
	shop.show()
	shop.position.x = 0
	showPlayer1Buttons(true)
	showPlayer2Buttons(false)

func buildStage2():
	shop.position.x = -580
	showPlayer1Buttons(false)
	showPlayer2Buttons(true)

func shootingStage():
	shop.hide()
	showPlayer2Buttons(false)

func showPlayer1Buttons(_bool):
	if(_bool):
		p_1_placement.show()
		p_1_ready.show()
	else:
		p_1_placement.hide()
		p_1_ready.hide()
	
func showPlayer2Buttons(_bool):
	if(_bool):
		p_2_placement.show()
		p_2_ready.show()
	else:
		p_2_placement.hide()
		p_2_ready.hide()

func setDamageable():
	print("damageable")
	for box in p1Boxes:
		box.damageable = true
	for box in p2Boxes:
		box.damageable = true
	damageable = true
	

func _on_p_1_ready_pressed() -> void:
	p1Ready = true
	p_1_ready.visible = false
	buildStage2()


func _on_p_2_ready_pressed() -> void:
	p2Ready = true
	p_2_ready.visible = false
	setDamageable()
	shootingStage()


func _on_p_1_placement_pressed() -> void:
	if(p1.money >= BOX.price):
		p1.money -= BOX.price
		p1MoneyLabel.text = p1.getMoney()
		var newBox = box.instantiate()
		newBox.position = $Camera2D.get_global_mouse_position()
		newBox.setUp(BOX, p2Ready and p1Ready)
		add_child(newBox)
		p1.addBox(newBox)


func _on_p_2_placement_pressed() -> void:
	if(p2.money >= BOX.price):
		p2.money -= BOX.price
		var newBox = box.instantiate()
		newBox.position = $Camera2D.get_global_mouse_position()
		newBox.setUp(BOX, p2Ready and p1Ready)
		add_child(newBox)
		p2.addBox(newBox)


func _on_box_1_pressed() -> void:
	BOX = BOX_1 # Replace with function body.

func _on_box_2_pressed() -> void:
	BOX = BOX_2 # Replace with function body.

func _on_box_3_pressed() -> void:
	BOX = BOX_3
