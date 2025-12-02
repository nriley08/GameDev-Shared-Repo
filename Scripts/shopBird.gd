extends Button

@export var bird : BirdInfo

func _ready():
	icon = bird.sprite
	text = "$" + str(bird.price) + ", damage: " + str(bird.damage)
