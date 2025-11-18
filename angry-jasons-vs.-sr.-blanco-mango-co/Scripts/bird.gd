extends RigidBody2D
class_name Bird

@export var sprite_2d: Sprite2D #= $Sprite2D
@export var collision_shape_2d: CollisionShape2D # $Area2D/CollisionShape2D

func setUp(info : BirdInfo):
	sprite_2d.texture = info.sprite
	var shape = CircleShape2D.new()
	shape.radius = info.radius
	collision_shape_2d.shape = shape
	sprite_2d.modulate = Color(info.modulate.x,info.modulate.y,info.modulate.z)



func _on_area_2d_body_entered(_body: Node2D) -> void:
	print(int(linear_velocity.y) / 100)
	_body.health -= int(linear_velocity.y) / 100
