extends Node2D

@onready var hitbox: Hitbox = %Hitbox
@onready var hitbox2: Hitbox = %Hitbox2
@onready var hitbox3: Hitbox = %Hitbox3
@onready var hitbox4: Hitbox = %Hitbox4
@onready var shield_bash: Hitbox = %ShieldBash

func set_disabled(value : bool):
	hitbox.set_disabled(value)
	hitbox2.set_disabled(value)
	hitbox3.set_disabled(value)
	hitbox4.set_disabled(value)
	shield_bash.set_disabled(value)
