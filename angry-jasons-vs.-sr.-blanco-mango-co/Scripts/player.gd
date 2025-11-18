extends Node
class_name Player

var money : int
var birds : Array[BirdInfo]
var lives : int
@export var mango : Area2D
var mangoHealth : int
var boxes : Array[Box]
var totalHealth

func getBird():
	if(len(birds) > 0):
		return birds.pop_front()
	else:
		return null

func addBird(bird : BirdInfo):
	birds.append(bird)

func init():
	money = 1000
	lives = 3
	mangoHealth = 100

func getMoney():
	return str(money)
	
func spend(amount : int) -> bool:
	if(money < amount):
		return false
	money -= amount
	return true

func addBox(box : Box):
	boxes.append(box)

func getTotalHealth():
	for box in boxes:
		totalHealth += box.health
