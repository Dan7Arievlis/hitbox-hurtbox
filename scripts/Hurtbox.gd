extends Area2D
class_name Hurtbox

@export var hurtbox_resource : HurtboxResource
@onready var collision_shape_2d : CollisionShape2D = $CollisionShape2D

signal hurtbox_hit(hit : Hit)
signal force_applied(force : Vector2)
signal hurtbox_destroyed(hurtbox : Hurtbox)
signal hurtbox_area_entered(hitbox : Hitbox, hurtbox : Hurtbox)
signal hurtbox_area_exited(hitbox : Hitbox)

var life : float
var shield : Shield

var hits : Dictionary[Hitbox, Hit]


func _ready() -> void:
	set_hurtbox(hurtbox_resource)
	life = hurtbox_resource.max_life


func set_shield(_shield : Shield) -> void:
	shield = _shield


func set_hurtbox_shape(shape : Shape2D, pos : Vector2):
	collision_shape_2d.shape = shape
	collision_shape_2d.position = pos


func set_hurtbox(_hurtbox_resource : HurtboxResource):
	hurtbox_resource = _hurtbox_resource
	collision_layer = hurtbox_resource.collision_layer
	collision_mask = hurtbox_resource.collision_mask
	
	collision_shape_2d.shape = hurtbox_resource.collision_shape
	collision_shape_2d.position = hurtbox_resource.position


func set_disabled(value : bool) -> void:
	collision_shape_2d.set_deferred("disabled", value)


func add_hit(hit : Hit):
	hits.get_or_add(hit.dealer, hit)


func remove_hit(dealer : Hitbox):
	hits.erase(dealer)


func _on_area_entered(area: Area2D) -> void:
	if not area is Hitbox:
		return
	hurtbox_area_entered.emit(area as Hitbox, self)
	call_deferred("register_hit", area as Hitbox)


func register_hit(hitbox : Hitbox):
	if not hits:
		return
	
	var hit : Hit = hits.get(hitbox)
	if shield and shield.blocked_hitboxes.has(hitbox):
		hit = hit.apply_shield_modifiers(shield)
	
	hurtbox_hit.emit(hit)
	life -= hit.damage
	apply_force(hit)
	
	if life <= 0.0:
		hurtbox_destroyed.emit(self)


func i_frames():
	if not get_tree():
		return
	
	set_disabled(true)
	await get_tree().create_timer(hurtbox_resource.invulnerability_cooldown).timeout
	set_disabled(false)


func apply_force(hit : Hit):
	var kb_force := (hit.target.global_position - hit.dealer.global_position).normalized() * hit.knockback_force + hit.kb_modifier
	var kb_resistance := 1 - hit.target.hurtbox_resource.kb_resistance
	kb_force *= kb_resistance
	force_applied.emit(kb_force)


func _on_area_exited(area: Area2D) -> void:
	if not area is Hitbox:
		return
	area = area as Hitbox
	hurtbox_area_exited.emit(area)
	remove_hit(area)
