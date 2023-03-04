extends Control


# Declare member variables here. Examples:
var dragging = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if(dragging): # Performance
		$SliderVal.text = str($HSlider.value) + ' mpg'


func _on_HSlider_drag_ended(value_changed):
	dragging = false


func _on_HSlider_drag_started():
	dragging = true
