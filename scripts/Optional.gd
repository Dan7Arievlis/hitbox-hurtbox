extends Node

func or_else(param, other):
	if param == null:
		return other
	return param
