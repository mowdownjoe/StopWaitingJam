extends Area2D

signal hit

export var speed = 400
export (PackedScene) var bullet
export var bullet_speed = 500
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_movement(delta)
	#process_firing()
	
func process_movement(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		position += velocity * delta
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		position += velocity * delta
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		position += velocity * delta
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		position += velocity * delta
		
	if velocity.length() > 0 :
		velocity = velocity.normalized() * speed
		
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
func process_firing():
	if Input.is_action_just_pressed("fire"):
		var shot_fired = bullet.instance()
		shot_fired.add_group("player")
		add_child(shot_fired)
		shot_fired.position = position
		shot_fired.linear_velocity = Vector2(0, bullet_speed)
	


func _on_Player_body_entered(body):
	var body_groups = body.get_groups()
	print_debug(body_groups)
	if body_groups.has("enemy"):
		emit_signal("hit")
	
