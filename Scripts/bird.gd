extends RigidBody2D
class_name Bird

@onready var timer: Timer = $Timer

@export var sprite_2d: Sprite2D #= $Sprite2D
@export var collision_shape_2d: CollisionShape2D # $Area2D/CollisionShape2D
@export var areashape: CollisionShape2D # $Area2D/CollisionShape2D
var damage : float
'''
* set up bird
*
* @param BirdInfo
* @return nothing
* @throws nothing
'''
func setUp(info : BirdInfo):
	sprite_2d.texture = info.sprite
	var shape = CircleShape2D.new()
	shape.radius = info.radius
	collision_shape_2d.shape = shape
	var aShape = CircleShape2D.new()
	aShape.radius = info.radius * 1.1
	areashape.shape = aShape
	sprite_2d.modulate = Color(info.modulate.x,info.modulate.y,info.modulate.z)
	damage = info.damage

func _ready():
	timer.start(5)
'''
* subtract health from box it collides with
*
* @param body
* @return nothing
* @throws nothing
'''
func _on_area_2d_body_entered(_body: Node2D) -> void:
	#if(_body)
	_body.subtractHealth(int(abs(linear_velocity.length()*damage))/100)


func _on_timer_timeout() -> void:
	queue_free()
