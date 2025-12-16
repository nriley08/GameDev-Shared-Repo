extends Node2D
@onready var win: Label = $CanvasLayer/win

@onready var p_1_slingshot: AnimatedSprite2D = $P1Slingshot
@onready var p_2_slingshot: AnimatedSprite2D = $P2Slingshot
@onready var timer: Timer = $Timer
@onready var time: Label = $CanvasLayer/Time
@onready var p1mango: Mango = $p1Mango
@onready var p2mango: Mango = $p2Mango
const MANGOBOX = preload("res://Resources/mangoTree.tres")

@export var box : PackedScene
@export var bird : PackedScene
@onready var p1MoneyLabel: Label = $CanvasLayer/P1MoneyLabel
@onready var p2MoneyLabel: Label = $CanvasLayer/P2MoneyLabel
var p1 : Player
var p2 : Player
var i = 0
var damageable := false

#shops
@onready var bird_shop: Node2D = $BirdShop
@onready var shop: Node2D = $BoxShop
@onready var p_1_placement: Button = $P1Placement
@onready var p_2_placement: Button = $P2Placement

#boxes for shop
const BOX_1 = preload("res://Resources/box1.tres")
var BOX = BOX_1
const BOX_2 = preload("res://Resources/box2.tres")
const BOX_3 = preload("res://Resources/box3.tres")
#birds for shop
const BIRD_1 = preload("res://Resources/bird1.tres")
var p1birdShop := false

@onready var p_1_ready: Button = $P1Ready
@onready var p_2_ready: Button = $P2Ready

var p1Ready := false # bool for stages
var p2Ready := false


var p1Direction := 1
var p1Power : float
var p2Direction := 1
var p2Power : float
@export var powerMax : float
@export var increaseValue : float
'''
* set players and shops up
*
* @param nothing
* @return nothing
* @throws nothing
'''
func _ready() -> void:
	bird_shop.hide()
	p1 = Player.new()
	p1.player = "Player 2"
	p2 = Player.new()
	p2.player = "Player 1"
	p1.init()
	p2.init()
	p1.connect("endGame", endGame.bind())
	p2.connect("endGame", endGame.bind())
	#print(len(p1.birds))
	p1MoneyLabel.text = p1.getMoney()
	p2MoneyLabel.text = p2.getMoney()
	buildStage1()
	p1Power = 1
	p2Power = 1
	p1.setUpMango(MANGOBOX, p1mango)
	p2.setUpMango(MANGOBOX, p2mango)
'''
* handle shooting + timer for round
*
* @param _delta
* @return nothing
* @throws nothing
'''
func _process(_delta):
	time.text = str(int(timer.get_time_left()))
	if(damageable):
		#p1 shooting
		if(Input.is_action_pressed("p1shoot")):
			p1Power += increaseValue * p1Direction
			if(p1Power > powerMax):
				p1Power = powerMax
				p1Direction = -1
			elif(p1Power < 1):
				p1Power = 1
				p1Direction = 1
		elif(p1Power != 1):
			p1Shoot()
			p1Power = 1
			p1Direction = 1
		#p2 shooting
		if(Input.is_action_pressed("p2shoot")):
			p2Power += increaseValue * p2Direction
			if(p2Power > powerMax):
				p2Power = powerMax
				p2Direction = -1
			elif(p2Power < 1):
				p2Power = 1
				p2Direction = 1
		elif(p2Power != 1):
			p2Shoot()
			p2Power = 1
			p2Direction = 1
'''
* let p1 shoot
*
* @param nothing
* @return nothing
* @throws nothing
'''
func p1Shoot():
	var newBirdInfo = p1.getBird()
	if(newBirdInfo == null):
		p1Ready = false
		if(p1Ready == p2Ready):
			endRound()
		return
	else:
		var newBird = bird.instantiate()
		newBird.setUp(newBirdInfo)
		newBird.position = p_1_slingshot.position
		newBird.apply_central_impulse(Vector2(.55,-1) * p1Power * 10)
		add_child(newBird)
'''
* let p2 shoot
*
* @param nothing
* @return nothing
* @throws nothing
'''
func p2Shoot():
	var newBirdInfo = p2.getBird()
	if(newBirdInfo == null):
		p2Ready = false
		if(p1Ready == p2Ready):
			endRound()
		return
	else:
		var newBird = bird.instantiate()
		newBird.setUp(newBirdInfo)
		newBird.position = p_2_slingshot.position
		newBird.apply_central_impulse(Vector2(-.55,-1) * p2Power * 10)
		add_child(newBird)
		
func buildStage1():
	shop.show()
	p1birdShop =true
	bird_shop.show()
	bird_shop.position.x = 110
	p_2_slingshot.hide()
	p2mango.hide()
	shop.position.x = -10
	showPlayer1Buttons(true)
	showPlayer2Buttons(false)

func buildStage2():
	p1birdShop =false #makes it so the bird takes money from p2 and not p1
	shop.position.x = -740
	bird_shop.position.x = -470
	p_2_slingshot.show()
	p2mango.show()
	showPlayer1Buttons(false)
	showPlayer2Buttons(true)
	p_1_slingshot.hide()
	p1mango.hide()

"func birdStage1():
p1birdShop = true
shop.hide()
bird_shop.show()
shop.position.x = 0
p_1_ready.show()
showPlayer2Buttons(false)
p_1_slingshot.show()
p1mango.show()
func birdStage2():
p1birdShop = false
bird_shop.position.x = -580
showPlayer1Buttons(false)
p_2_ready.show()"

func shootingStage():
	timer.start(60)
	bird_shop.hide()
	shop.hide()
	showPlayer2Buttons(false)
	bird_shop.hide()
	p1mango.show()
	p_1_slingshot.show()
'''
* show or hide p1 placement and ready buttons
*
* @param bool
* @return nothing
* @throws nothing
'''
func showPlayer1Buttons(_bool):
	if(_bool):
		p_1_placement.show()
		p_1_ready.show()
	else:
		p_1_placement.hide()
		p_1_ready.hide()
'''
* show or hide p2 placement and ready buttons
*
* @param bool
* @return nothing
* @throws nothing
'''
func showPlayer2Buttons(_bool):
	if(_bool):
		p_2_placement.show()
		p_2_ready.show()
	else:
		p_2_placement.hide()
		p_2_ready.hide()
'''
* set boxes damageable after building
*
* @param nothing
* @return nothing
* @throws nothing
'''
func setDamageable():
	#print("damageable")
	p1.setDamageable()
	p2.setDamageable()
	damageable = true

'''
* called when p1 ready button pressed - start next phase
*
* @param nothing
* @return nothing
* @throws nothing
'''
func _on_p_1_ready_pressed() -> void:
	p1Ready = true
	p_1_ready.visible = false
	buildStage2()



'''
* called when p2 ready button pressed - start next phase
*
* @param nothing
* @return nothing
* @throws nothing
'''
func _on_p_2_ready_pressed() -> void:
	p2Ready = true
	p_2_ready.visible = false
	setDamageable()
	shootingStage()

'''
* called when p1 placement button pressed - place box
*
* @param nothing
* @return nothing
* @throws nothing
'''
func _on_p_1_placement_pressed() -> void:
	if(p1.money >= BOX.price):
		p1.money -= BOX.price
		p1MoneyLabel.text = p1.getMoney()
		var newBox = box.instantiate()
		newBox.position = $Camera2D.get_global_mouse_position()
		newBox.setUp(BOX, damageable)
		add_child(newBox)
		p1.addBox(newBox)

'''
* called when p2 placement button pressed - place box
*
* @param nothing
* @return nothing
* @throws nothing
'''
func _on_p_2_placement_pressed() -> void:
	if(p2.money >= BOX.price):
		p2.money -= BOX.price
		p2MoneyLabel.text = p2.getMoney()
		var newBox = box.instantiate()
		newBox.position = $Camera2D.get_global_mouse_position()
		newBox.setUp(BOX, damageable)
		add_child(newBox)
		p2.addBox(newBox)

'''
* called when box from box shop chosen - set BOX to place to box
*
* @param nothing
* @return nothing
* @throws nothing
'''
func _on_box_1_pressed() -> void:
	BOX = BOX_1 # Replace with function body.
'''
* called when box from box shop chosen - set BOX to place to box
*
* @param nothing
* @return nothing
* @throws nothing
'''
func _on_box_2_pressed() -> void:
	BOX = BOX_2 # Replace with function body.
'''
* called when box from box shop chosen - set BOX to place to box
*
* @param nothing
* @return nothing
* @throws nothing
'''
func _on_box_3_pressed() -> void:
	BOX = BOX_3 # Replace with function body.
'''
* end round - start next round
*
* @param nothing
* @return nothing
* @throws nothing
'''
func endRound():
	timer.stop()
	damageable = false
	p2.addMoney(p2.lives*100)
	p1.addMoney(p1.lives*100)
	p1MoneyLabel.text = p1.getMoney()
	p2MoneyLabel.text = p2.getMoney()
	buildStage1()
'''
* called when timer runs out - ends round
*
* @param nothing
* @return nothing
* @throws nothing
'''
func _on_timer_timeout() -> void:
	endRound()
'''
* called when bird from shop chosen - give player bird
*
* @param nothing
* @return nothing
* @throws nothing
'''
func _on_bird_1_pressed() -> void:
	if(p1birdShop):
		if(p1.money >= BIRD_1.price):
			p1.money -= BIRD_1.price
			p1.addBird(BIRD_1)
			p1MoneyLabel.text = p1.getMoney()
	else:
		if(p2.money >= BIRD_1.price):
			p2.money -= BIRD_1.price
			p2.addBird(BIRD_1)
			p2MoneyLabel.text = p2.getMoney()

'''
* called when a mango tree dies
*
* @param player that won
* @return nothing
* @throws nothing
'''
func endGame(player : String):
	win.text = player + " won!"	
