extends TextureButton
class_name InventoryListItem

signal selected( item:InventoryListItem )

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
