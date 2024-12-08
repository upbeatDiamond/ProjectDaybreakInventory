extends TextureButton
class_name InventoryListItem

signal selected( item:InventoryListItem )

var count : int = 0
var text : String = ""
var item = "null"

@onready var count_label = $Count
@onready var name_label = $HBoxContainer/Name


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed():
	print("Yippee!")


func _on_focus_entered():
	
	pass


func _on_focus_exited():
	pass


func set_count(_count:int=count):
	count = _count
	count_label.text = str("x", count)
