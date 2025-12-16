extends RigidBody2D
class_name Mango

@onready var animation_player: AnimationPlayer = $Label/AnimationPlayer

signal Died()
@export var health := 100
var damageable := false
@export var sprite_2d: Sprite2D #= $Sprite2D
@export var collision_shape_2d: CollisionShape2D # $Area2D/CollisionShape2D
@export var areashape: CollisionShape2D # $Area2D/CollisionShape2D
@export var healthLabel: Label
'''
* set up mango
*
* @param BoxInfo, bool
* @return nothing
* @throws nothing
'''
func setUp(info : BoxInfo, _damageable : bool):
	sprite_2d.texture = info.sprite
	health = info.health
	healthLabel.text = str(health)
	var shape = RectangleShape2D.new()
	shape.extents = info.sprite.get_size()/2
	collision_shape_2d.shape = shape
	var aShape = RectangleShape2D.new()
	aShape.extents = info.sprite.get_size() /2* 1.1
	areashape.shape = aShape
	damageable = _damageable
	sprite_2d.modulate = Color(info.modulate.x,info.modulate.y,info.modulate.z)

func setDamageable():
	damageable = true
	
func setNotDamageable():
	damageable = false
'''
* subtract health. if dead, tell player via signal
*
* @param amount
* @return nothing
* @throws nothing
'''
func subtractHealth(amount : int):
	health -= amount
	if(health <= 0):
		health = 0
		Died.emit()
		animation_player.play("die")
		await get_tree().create_timer(1.0).timeout
		animation_player.play("RESET")
	else:
		healthLabel.text = str(health)
'''
* subtract health if collides with a box
*
* @param body
* @return nothing
* @throws nothing
'''
func _on_area_2d_body_entered(_body: Node2D) -> void:
	if(damageable):
		subtractHealth(int(abs(linear_velocity.length())/100))
	if(_body.damageable):
		_body.subtractHealth(int(abs(linear_velocity.length())/300))
