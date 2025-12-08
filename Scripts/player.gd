extends Node
class_name Player

var money : int
var birds : Array[BirdInfo]
var lives := 3
var mango : Mango
var mangoPosition : Vector2
var mangoInfo : BoxInfo
var boxes : Array[Box]
var totalHealth
var player : String
signal endGame(player)
const MANGO = preload("res://Scenes/mango.tscn")
'''
* set up the mango with data from the main scene
*
* @param BoxInfo, Mango (position)
* @return nothing
* @throws nothing
'''
func setUpMango(info : BoxInfo, box : Mango):
	mango = box
	mangoPosition = Vector2(mango.position)
	mangoInfo = info
	mango.setUp(info, false)
	mango.connect("Died", onMangoDied.bind())
'''
* called from signal when mango dies
*
* @param nothing
* @return nothing
* @throws nothing
'''
func onMangoDied():
	lives -= 1
	print("h")
	if(lives <= 0):
		print("Died")
		mango.queue_free()
		endGame.emit(player)
	else:
		mango.subtractHealth(-mangoInfo.health)
'''
* get a bird from the birds list to shoot
*
* @param nothing
* @return bird
* @throws nothing
'''
func getBird():
	if(len(birds) > 0):
		return birds.pop_front()
	else:
		return null
'''
* add a bird to birds array
*
* @param BirdInfo
* @return nothing
* @throws nothing
'''
func addBird(bird : BirdInfo):
	birds.append(bird)
'''
* init p1
*
* @param nothing
* @return nothing
* @throws nothing
'''
func init():
	money = 1000
	lives = 3

func getMoney():
	return str(money)
'''
* check if you can buy something, subtract amount if you can
*
* @param cost
* @return true or false
* @throws nothing
'''
func spend(amount : int) -> bool:
	if(money < amount):
		return false
	money -= amount
	return true

func addBox(box : Box):
	print("box added")
	boxes.append(box)
'''
* called at start of round, set everything damageable
*
* @param nothing
* @return nothing
* @throws nothing
'''
func setDamageable():
	mango.setDamageable()
	for i in range(0,len(boxes)):
		if(boxes[i] != null):
			boxes[i].setDamageable()
		else:
			boxes.pop_at(i)
			i-=1
	totalHealth = getTotalHealth()
'''
* called at end of round, check total health of boxes
*
* @param 
* @return nothing
* @throws nothing
'''
func getTotalHealth() -> int:
	mango.setNotDamageable()
	var sum : int
	for box in boxes:
		if(box != null):
			sum += box.health
	if(sum > 0):
		return sum
	return 1

func getDamage():
	if(totalHealth == 1):
		return 0
	return getTotalHealth()/float(totalHealth) * 10
	
func addMoney(amount : int):
	money += amount
