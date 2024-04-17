extends Node3D


@export var fire_rate : float


@onready var cooldown: Timer = $Cooldown



func _process(delta: float) -> void:
    if Input.is_action_pressed("fire"):
        if cooldown.is_stopped():
            cooldown.start(1.0 / fire_rate)
            print ("Weapon fired!")
