extends RichTextLabel

@export var dialogue: Array[String] = []
@export var dooor = false
@export var caar = false

@onready var thing = get_parent()

var current_line: int = 0
var is_typing: bool = false
var current_dialogue = []
var f_line = false

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
				if f_line == false:
					f_line = true
				else:
					thing.clear()

func next_line():
	if not is_typing:
		current_line += 1
		if current_line < current_dialogue.size():
			start_dialogue_line(current_dialogue, current_line)
		else:
			text = ""

func start_dialogue_line(d, index: int) -> void:
	text = d[index]
	visible_characters = 0
	type_timer = 0.0
	is_typing = true
