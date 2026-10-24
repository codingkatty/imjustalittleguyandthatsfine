extends Node2D

@export var tile_map_layer: TileMapLayer
@export var source_id: int = 0
@export var atlas_coords: Vector2i = Vector2i(0, 0)

var is_drawing: bool = false
var drawed = false
var draw_number = 0
var started = false
var current_draw = 1

var room = preload("res://scenes/room.tscn")

func _ready() -> void:
	started = true
	$patterns.visible = true
	$draw.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and drawed == false and started:
		is_drawing = event.pressed

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and started:
		drawed = true
		$dialog.next_line()

var pattern: TileMapLayer
var pattern_show: TileMapLayer

func clear():
	tile_map_layer.clear()
	drawed = false

	if current_draw < 7:
		pattern = get_node("patterns/pattern%s" % current_draw)
		current_draw += 1
		pattern_show = get_node("patterns/pattern%s" % current_draw)

		pattern.visible = false
		pattern_show.visible = true
	else:
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_packed(room)

func _process(_delta: float) -> void:
	if is_drawing:
		var mouse_pos: Vector2 = get_global_mouse_position()
		var cell_pos: Vector2i = tile_map_layer.local_to_map(tile_map_layer.to_local(mouse_pos))

		if tile_map_layer.get_cell_atlas_coords(cell_pos) != atlas_coords:
			draw_number += 1

		tile_map_layer.set_cell(cell_pos, source_id, atlas_coords)
