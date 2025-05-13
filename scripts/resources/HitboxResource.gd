@tool
extends ShapeResource
class_name HitboxResource

# Area settings
@export_group("Area 2D")
@export_flags_2d_physics var collision_layer : int
@export_flags_2d_physics var collision_mask : int

@export_group("Stats")
@export var one_shot : bool
@export var animate : bool = true
@export var damage : float
@export var knockback_force : float
@export var kb_modifier : Vector2
