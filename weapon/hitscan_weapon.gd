extends Node3D


@export var fire_rate : float
@export var recoil : float = 0.05
@export var player_damage : int = 5
@export var weapon_mesh : Node3D



@onready var cooldown: Timer = $Cooldown
@onready var weapon_position : Vector3 = weapon_mesh.position
@onready var ray_cast_3d: RayCast3D = $RayCast3D


func _process(delta: float) -> void:
    if Input.is_action_pressed("fire"):
        if cooldown.is_stopped():
            shoot()
        
    weapon_mesh.position = weapon_mesh.position.lerp(weapon_position, delta * 10.0)


func shoot() -> void:
    var collider = ray_cast_3d.get_collider()
    cooldown.start(1.0 / fire_rate)
    printt("Weapon fired!", collider)
    weapon_mesh.position.z += recoil
    if collider is Enemy:
        collider.enemy_health -= player_damage
