extends Control
class_name InventoryList

var item_slots : Array[TextureButton] = []
const INVENTORY_SLOT = preload("res://inventory/inventory_slot.tscn")
@onready var slot_list = $ScrollContainer/VBoxContainer

## 0-indexed
var current_selected := 0
var busy := false



signal busy_ended


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_pressed("make"):
		_add_entry(str(randi_range(0, 1024)), randi_range(1, 64) )
	if Input.is_action_pressed("kill"):
		clear_entries()
	
	
	pass


func _on_focus_entered():
	pass


func clear_entries():
	
	for item in slot_list.get_children():
		item.queue_free()
	
	pass


## If the item cannot be found, add it to the list
## Set the item count to 'count'.
## If 'item' is a tag, change it to the index. If the index cannot be found, use a hash of the tag.
func set_entry(item, count:int):
	pass


func _add_entry(item, count:int):
	
	## Mutex to reduce chance of list corruption
	if busy:
		await busy_ended
	busy = true
	
	## Create the item slot
	var entry = INVENTORY_SLOT.instantiate()
	entry.item = item
	entry.count = count
	
	## Resort all the slots to ensure that the entry is in the correct position
	var sorted_nodes := slot_list.get_children().duplicate()
	sorted_nodes.append(entry)
	sorted_nodes.sort_custom(_sort_slots)
	
	for node in slot_list.get_children():
		slot_list.remove_child(node)
	
	for node in sorted_nodes:
		slot_list.add_child(node)
	
	## Have the neighbors properly assigned, so if the overall display fails, 
	## the keyboard input still works.
	for node in slot_list.get_children():
		var node_index = slot_list.get_children().find(node)
		if node_index > 0:
			var neighbor = slot_list.get_children()[node_index-1]
			node.focus_neighbor_top = neighbor.get_path()
			neighbor.focus_neighbor_bottom = node.get_path()
		
		if node_index + 1 < slot_list.get_children().size():
			var neighbor = slot_list.get_children()[node_index+1]
			node.focus_neighbor_bottom = neighbor.get_path()
			neighbor.focus_neighbor_top = node.get_path()
	
	busy = false
	busy_ended.emit()


# For descending order use > 0
func _sort_slots(a:InventoryListItem, b:InventoryListItem):
	if a.list_index < b.list_index:
		return true
	elif a.list_index > b.list_index:
		return false
	else:
		return a.text < b.text


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
