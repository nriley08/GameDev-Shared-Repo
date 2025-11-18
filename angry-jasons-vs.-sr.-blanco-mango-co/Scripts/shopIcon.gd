extends Button

@export var box : BoxInfo

func _ready():
	icon = box.sprite
	text = "$" + str(box.price) + ", health: " + str(box.health)
