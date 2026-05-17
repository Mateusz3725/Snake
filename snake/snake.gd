extends Node2D

var snake = []
var cell_size = 40
var direction = Vector2.RIGHT

var move_delay = 0.2
var timer = 0.0

var screen_size = Vector2(760, 760)

var snake_texture = preload("res://Snake.png")
var food_texture = preload("res://Apple.png")

var colors = ["2a9000", "4f870a", "4f87c1", "a85498", "9550cd", "35a69b", "dec231", "de5531", "e900f7", "8c01f0"]
var color = colors.pick_random()

var food = null

func _ready() -> void:
	
	randomize()
	
	var start_pos = Vector2(400, 400)
	
	for i in range(3):
		var segment = Sprite2D.new()
		segment.texture = snake_texture
		segment.centered = false
		segment.position = start_pos + Vector2(-i * cell_size, 0)
		
		var text_size = segment.texture.get_size()
		segment.scale = Vector2(cell_size / text_size.x, cell_size / text_size.y)
		
		segment.self_modulate = Color(color)
		
		add_child(segment)
		snake.append(segment)
	
	spawn_food()


func _process(delta: float) -> void:
	handle_input()
	timer += delta
	if timer > move_delay:
		timer = 0
		move_snake()


func move_snake():
	var new_head_pos = snake[0].position + direction * cell_size
	
	if new_head_pos.x < 0:
		new_head_pos.x = screen_size.x
	elif new_head_pos.x > screen_size.x:
		new_head_pos.x = 0
	
	if new_head_pos.y < 0:
		new_head_pos.y = screen_size.y
	elif new_head_pos.y > screen_size.y:
		new_head_pos.y = 0
	
	var new_head = Sprite2D.new()
	new_head.texture = snake_texture
	new_head.centered = false
	new_head.position = new_head_pos
	var text_size = new_head.texture.get_size()
	new_head.scale = Vector2(cell_size / text_size.x, cell_size / text_size.y)
	new_head.self_modulate = Color(color)
	add_child(new_head)
	snake.insert(0, new_head)
	
	for i in range(1, snake.size()):
		if snake[0].position == snake[i].position:
			get_tree().reload_current_scene()
	
	if food and snake[0].position == food.position:
		var tail = snake[-1]
		var new_tail = Sprite2D.new()
		new_tail.texture = snake_texture
		new_tail.centered = false
		new_tail.position = tail.position
		var text_size_tail = new_tail.texture.get_size()
		new_tail.scale = Vector2(cell_size / text_size_tail.x, cell_size / text_size_tail.y)
		add_child(new_tail)
		snake.append(new_tail)
		
		spawn_food()
	else:
		var tall = snake.pop_back()
		tall.queue_free()


func handle_input():
	if Input.is_action_pressed("up") and direction != Vector2.DOWN:
		direction = Vector2.UP
	if Input.is_action_pressed("down") and direction != Vector2.UP:
		direction = Vector2.DOWN
	if Input.is_action_pressed("left") and direction != Vector2.RIGHT:
		direction = Vector2.LEFT
	if Input.is_action_pressed("right") and direction != Vector2.LEFT:
		direction = Vector2.RIGHT


func spawn_food():
	var grid_size = screen_size / cell_size
	
	var x = (randi() % int(grid_size.x)) * cell_size
	var y = (randi() % int(grid_size.y)) * cell_size
	
	if food:
		food.queue_free()
	
	food = Sprite2D.new()
	food.texture = food_texture
	food.centered = false
	food.position = Vector2(x, y)
	
	var tex_size = food.texture.get_size()
	food.scale = Vector2(cell_size / tex_size.x, cell_size / tex_size.y)
	
	add_child(food)
	
	
