extends Area2D
class_name Hitbox

@export var hitbox_resource : HitboxResource
@onready var collision_shape_2d : CollisionShape2D = $CollisionShape2D

var hit : bool

func _ready() -> void:
		set_hitbox(hitbox_resource)


func set_hitbox(_hitbox_resource : HitboxResource):
	collision_layer = _hitbox_resource.collision_layer
	collision_mask = _hitbox_resource.collision_mask
	
	collision_shape_2d.shape = _hitbox_resource.collision_shape
	collision_shape_2d.position = _hitbox_resource.position


func set_disabled(value : bool) -> void:
	collision_shape_2d.disabled = value
	hit = false


func _on_area_entered(area: Area2D) -> void:
	if hitbox_resource.one_shot and hit:
		return
	if not area is Hurtbox:
		return
	area = area as Hurtbox
	
	area.add_hit(Hit.new(hitbox_resource.damage, hitbox_resource.knockback_force, self, area as Hurtbox, hitbox_resource.kb_modifier, hitbox_resource.animate))
	hit = true
