extends TextureButton
class_name InventoryListItem

signal selected( item:InventoryListItem )

var count : int = 0 :
	set(value):
		count_label = str("x", value)
		count = value
		dirty = true
	get:
		if count_label != null:
			return count_label.text.to_int()
		return count

var text : String = "" :
	set(value):
		name_label = str(value)
		text = value
		dirty = true
	get:
		if name_label != null:
			return name_label.text
		return text

var dirty := true
var item = "null"
var list_index : int = 0

@onready var count_label = $Count
@onready var name_label = $HBoxContainer/Name


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)
	_update_labels()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dirty:
		_update_labels()
	pass


func _update_labels():
	var clean = true
	
	## If the count didn't change, it's still dirty.
	if count_label != null:
		count_label.text = str(count)
	else:
		clean = false
	
	## If the name didn't change, it's still dirty.
	if name_label != null:
		name_label.text = str(item)
	else:
		clean = false
	
	dirty = not clean ## If anything failed, the slot remains dirty.


func _on_pressed():
	print("Yippee!")


func _on_focus_entered():
	
	pass


func _on_focus_exited():
	pass


func set_count(_count:int=count):
	count = _count
	count_label.text = str("x", count)
