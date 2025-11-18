extends RigidBody2D
class_name Box

@export var health := 100
var damageable := false
@export var sprite_2d: Sprite2D #= $Sprite2D
@export var collision_shape_2d: CollisionShape2D # $Area2D/CollisionShape2D
@export var areashape: CollisionShape2D # $Area2D/CollisionShape2D

func setUp(info : BoxInfo, _damageable : bool):
	sprite_2d.texture = info.sprite
	health = info.health
	var shape = RectangleShape2D.new()
	shape.extents = info.sprite.get_size()
	collision_shape_2d.shape = shape
	damageable = _damageable
	sprite_2d.modulate = Color(info.modulate.x,info.modulate.y,info.modulate.z)



func _on_area_2d_body_entered(_body: Node2D) -> void:
	if(damageable):
		health -= int(linear_velocity.y) / 100
		print(linear_velocity.y / 100)
		print(health)
