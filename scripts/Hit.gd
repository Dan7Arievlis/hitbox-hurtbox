extends Node
class_name Hit

var target : Hurtbox
var dealer : Hitbox
var damage : float
var knockback_force : float
var kb_modifier : Vector2 
var animate : bool


func _init(_damage : float, _knockback_force : float, _dealer : Hitbox, _target : Hurtbox, _kb_modifier : Vector2, _animate : bool) -> void:
	damage = _damage
	knockback_force = _knockback_force
	dealer = _dealer
	target = _target
	kb_modifier = _kb_modifier
	animate = _animate


func apply_shield_modifiers(shield : Shield) -> Hit:
	var hurtbox : Hurtbox = shield.blocked_hitboxes.get(dealer)
	var new_damage = damage * (1 - shield.damage_negation)
	var new_target = hurtbox
	var new_knockback_force = knockback_force * (1 - hurtbox.hurtbox_resource.kb_resistance)
	var new_animate = shield.animate
	
	return Hit.new(new_damage, new_knockback_force, dealer, new_target, kb_modifier, new_animate)
