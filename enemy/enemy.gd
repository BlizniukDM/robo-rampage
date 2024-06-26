class_name Enemy extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


@export var attack_range : float
@export var max_enemy_health : int = 100
@export var enemy_damage: int = 20


@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var player : CharacterBody3D
var provoked: bool = false
var aggro_range : float = 12.0

var enemy_health: int = max_enemy_health:
    set(current_enemy_health):
        enemy_health = current_enemy_health
        if enemy_health <= 0:
            queue_free()
        provoked = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
    player = get_tree().get_first_node_in_group("player")
    

func _process(_delta: float) -> void:
    if provoked:
        navigation_agent_3d.target_position = player.global_position
        

func _physics_process(delta: float) -> void:
    var next_position = navigation_agent_3d.get_next_path_position()
    # Add the gravity.
    if not is_on_floor():
        velocity.y -= gravity * delta

    var direction = global_position.direction_to(next_position)
    var distance = global_position.distance_to(player.global_position)
    if distance <= aggro_range:
        provoked = true
        
    if provoked:
        if distance <= attack_range:
            animation_player.play("attack")
            
    
    if direction:
        look_at_target(direction)
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

    move_and_slide()


func look_at_target(direction : Vector3) -> void:
    var adjusted_direction = direction
    adjusted_direction.y = 0
    look_at(global_position + adjusted_direction, Vector3.UP, true)


func attack() -> void:
    player.player_health -= enemy_damage
    print("Attack!")
