extends Node


@export var label: String = "None: %s"
@export var max_count: int = 1
@export var count: int

func _ready():
	update_text()
	$"Left Button".connect("pressed", on_prev_button)
	$"Right Button".connect("pressed", on_next_button)

func on_prev_button():
	count = clamp(count - 1, 0, max_count - 1)
	update_text()

func on_next_button():
	count = clamp(count + 1, 0, max_count - 1)
	update_text()

func update_text():
	$Label.text = label % count
