extends Control
class_name InventoryList

var item_slots : Array[TextureButton] = []
const INVENTORY_SLOT = preload("res://inventory/inventory_slot.tscn")
@onready var slot_list = $ScrollContainer/VBoxContainer

## 0-indexed
var current_selected := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_focus_entered():
	pass


func clear_entries():
	pass


## If the item cannot be found, add it to the list
## Set the item count to 'count'.
## If 'item' is a tag, change it to the index. If the index cannot be found, use a hash of the tag.
func set_entry(item, count:int):
	pass


func _add_entry(item, count:int):
	var entry = INVENTORY_SLOT.instantiate()
	slot_list.add_child(entry)
	
	pass


func set_selection_index(index:int):
	
	item_slots[current_selected].set_pressed_no_signal(false)
	
	if abs(index) < item_slots.size():
		current_selected = index
	else:
		current_selected = index % item_slots.size()
	
	item_slots[current_selected].set_pressed_no_signal(true)


func selection_move_down():
	set_selection_index(current_selected + 1)

func selection_move_up():
	set_selection_index(current_selected - 1)
