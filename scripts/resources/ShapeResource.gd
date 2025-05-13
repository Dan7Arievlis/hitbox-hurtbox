@tool
extends Resource
class_name ShapeResource

const DEFAULT_COLOR : Color = Color(0, 0.60, 0.70, 0.41)

var colors_keys : Array = Colors.keys()
var colors_list : String = ",".join(colors_keys)
enum Colors {
	BLUE,
	GREEN,
	RED,
}

# Shape settings
@export_group("Collision Shape")
@export var collision_shape : Shape2D
@export var position : Vector2
var color_color_name : int :
	set(value):
		color_color_name = value
		match value:
			Colors.GREEN:
				color_debug_color = Color.from_string("00a44e6b", DEFAULT_COLOR)
			Colors.RED:
				color_debug_color = Color.from_string("ff00006b", DEFAULT_COLOR)
			_:
				color_debug_color = DEFAULT_COLOR
		notify_property_list_changed()
var color_debug_color : Color = DEFAULT_COLOR

func _get_property_list() -> Array[Dictionary]:
	var properties : Array[Dictionary] = []
	properties.append({
		"name": "Color",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP,
		"hint_string": "color"
	})
	properties.append({
		"name": "color_color_name",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": colors_list
	})
	properties.append({
		"name": "color_debug_color",
		"type": TYPE_COLOR,
		"usage": PROPERTY_USAGE_DEFAULT,
	})
	
	return properties
