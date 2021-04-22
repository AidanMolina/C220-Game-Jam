extends KinematicBody2D

onready var Global = get_node("/root/Global")

onready var SM = $StateMachine
onready var tilemap = get_node_or_null("/root/Game/TileMap")

export var player_name : String
export var variant : int
export var fate : String

var velocity = Vector2(0.0, 0.0)
var normal_gravity = 1550.0
var jump_gravity = 900.0
var acceleration = Vector2(0.0, normal_gravity)
var move_speed = 300
var jump_speed = -560
var run_and_jump_speed = -640
var jump_released = true
var flipH = false
var default_coyote_time = 4.0 / 60.0 # seconds
var coyote_time = 0.0
var dead_timer = 0.0
var respawn_time = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Name.text = player_name
	add_to_group("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite.flip_h = flipH
	#$AnimatedSprite.offset.x = 1 if flipH else -1
	#if velocity.y > 0 and $AnimatedSprite.animation == "Jumping":
	#	$AnimatedSprite.play("Falling_Start")

func _physics_process(delta):
	if SM.state_name == "Dead":
		#$CollisionPolygon2D.disabled = true
		dead_timer += delta
		if dead_timer > respawn_time:
			pass
		return
	if Input.is_action_just_released("up"):
		jump_released = true
	velocity += acceleration * delta
	velocity = move_and_slide(velocity, Vector2.UP, false)
	handle_direction(Input.is_action_pressed("left"), Input.is_action_pressed("right"))
	if is_on_wall():
		velocity.x = 0
	coyote_time -= delta # delta because it's in seconds
	"""
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider == tilemap:
			# I test each collision at 4 different points just in case if it's on a bad edge or corner
			for x in [-1, 1]:
				for y in [-1, 1]:
					var tile = get_tile_at_pos(collision.position + Vector2(x * 0.1, y * 0.1))
					if tile == 14 or tile == 15: # steven tile
						die()
	var tile = get_tile_at_pos(position)
	match tile:
		2: # spikes
			die()
		4: # uppinators
			velocity.y += -Global.antigrav_tile_strength * delta
			if SM.state_name != "Falling":
				SM.set_state("Falling")
			set_animation("Falling")
		6: # oil
			set_tile_at_pos(position, TileMap.INVALID_CELL)
			Global.score += 1
		13: # oil on bg
			set_tile_at_pos(position, 12) # set to bg
			Global.score += 1
		16: # door, top
			Global.load_next_level()
			return
		17: # door, bottom
			Global.load_next_level()
			return
	"""
	
func get_tile_at_pos(pos):
	var input_position = pos - tilemap.position
	input_position /= tilemap.scale.x
	var grid_position = tilemap.world_to_map(input_position)
	var tile = tilemap.get_cellv(grid_position)
	return tile
	
func set_tile_at_pos(pos, tile):
	var input_position = pos - tilemap.position
	input_position /= tilemap.scale.x
	var grid_position = tilemap.world_to_map(input_position)
	tilemap.set_cellv(grid_position, tile)

func die():
	SM.set_state("Dead")
	print(player_name + " " + fate)
	
func set_animation(anim):
	if $AnimatedSprite.animation != anim:
		$AnimatedSprite.play(anim)


func _on_AnimatedSprite_animation_finished():
	pass

func handle_direction(isleft, isright):
	if isleft != isright:
		flipH = isleft
