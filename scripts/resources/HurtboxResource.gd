@tool
extends ShapeResource
class_name HurtboxResource

# Area settings
@export_group("Area 2D")
@export_flags_2d_physics var collision_layer : int
@export_flags_2d_physics var collision_mask : int

@export_group("Stats")
@export var max_life : float
@export_range(0, 2, 0.01, "or_greater") var invulnerability_cooldown : float = 0.03
@export_range(0, 1, 0.01) var kb_resistance : float
