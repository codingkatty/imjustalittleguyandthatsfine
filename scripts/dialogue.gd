extends RichTextLabel

@export var dialogue: Array[String] = []
@export var dooor = false
@export var caar = false

@onready var thing = get_parent()

var current_line: int = 0
var is_typing: bool = false
var current_dialogue = []
var f_done = false
var dad = false
@export var f_scene = false

var door = preload("res://scenes/door.tscn")
var car = preload("res://scenes/car.tscn")
var sketch = preload("res://scenes/sketchbook.tscn")

@export var type_speed: float = 0.05 
var type_timer: float = 0.0

func _ready() -> void:
	current_dialogue = dialogue
	if dialogue.size() > 0:
		start_dialogue_line(dialogue, current_line)
	else:
		text = ""

func _process(delta: float) -> void:
	if is_typing:
		type_timer += delta
		if type_timer >= type_speed:
			type_timer = 0.0
			visible_characters += 1
			
			if visible_characters >= text.length():
				is_typing = false
				
	if Input.is_action_just_pressed("ui_accept"):
		if is_typing:
			visible_characters = text.length()
			is_typing = false
		else:
			current_line += 1
			if current_line < current_dialogue.size():
				start_dialogue_line(current_dialogue, current_line)
			else:
				text = ""
				Input.action_release("ui_accept")
				if dad == true:
					await get_tree().create_timer(1.0).timeout
					get_tree().change_scene_to_packed(door)
				elif f_done == true:
					await get_tree().create_timer(1.0).timeout
					%knocker.play()
					knocked()
				elif f_scene == true:
					thing.start()
				elif dooor == true:
					await get_tree().create_timer(1.0).timeout
					get_tree().change_scene_to_packed(car)
				elif caar == true:
					await get_tree().create_timer(1.0).timeout
					get_tree().change_scene_to_packed(sketch)

func start_dialogue_line(d, index: int) -> void:
	text = d[index]
	visible_characters = 0
	type_timer = 0.0
	is_typing = true

func first_done():
	current_line = 0
	f_done = true
	current_dialogue = ["wow! it really did it!", "oh whoops", "...", "thanks for helping..?"]
	start_dialogue_line(current_dialogue, current_line)

func knocked():
	dad = true
	current_line = 0
	current_dialogue = ["!!", "oh, its my dad...", "shoot.."]
	start_dialogue_line(current_dialogue, current_line)
