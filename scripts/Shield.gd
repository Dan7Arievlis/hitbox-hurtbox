extends Node2D
class_name Shield

@export var protected_areas : Array[Hurtbox]
@export var disabled : bool = true
@export var animate : bool = false
@export_range(0, 1, 0.01) var damage_negation : float

var shield_areas : Array[Hurtbox]
var blocked_hitboxes : Dictionary[Hitbox, Hurtbox]

func _ready() -> void:
	for child in get_children():
		if child is Hurtbox:
			child = child as Hurtbox
			shield_areas.append(child)
			child.hurtbox_area_entered.connect(_on_shield_area_entered)
			child.hurtbox_area_exited.connect(_on_shield_area_exited)
			child.set_disabled(disabled)
	
	protected_areas.map(func(h : Hurtbox): h.set_shield(self))


func set_disabled(value : bool):
	disabled = value
	shield_areas.map(func(h): h.set_disabled(disabled))


func _on_shield_area_entered(hitbox : Hitbox, hurtbox : Hurtbox) -> void:
	blocked_hitboxes.get_or_add(hitbox, hurtbox)


func _on_shield_area_exited(hitbox : Hitbox) -> void:
	blocked_hitboxes.erase(hitbox)
