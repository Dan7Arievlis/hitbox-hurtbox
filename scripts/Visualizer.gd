@tool
extends Node2D

@export var parent_node : Node2D
var resource : ShapeResource
var collision_shape : CollisionShape2D


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if is_instance_valid(parent_node):
			if not resource:
				var global_class :String = parent_node.get_script().get_global_name()
				resource = parent_node.get((global_class + "Resource").to_snake_case())
			if resource:
				update_shape()
	else:
		if get_child_count() > 0:
			remove_child(collision_shape)


func update_shape() -> void:
	if get_child_count() < 1:
		collision_shape = CollisionShape2D.new()
		add_child(collision_shape)
	collision_shape.shape = resource.collision_shape
	collision_shape.position = resource.position
	collision_shape.debug_color = resource.color_debug_color
