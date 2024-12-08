extends Control
class_name InventoryList

var item_slots : Array[TextureButton] = []
const INVENTORY_SLOT = preload("res://inventory/inventory_slot.tscn")
@onready var slot_list = $ScrollContainer/VBoxContainer

## 0-indexed; currently unused. Intended to avoid unneeded focus capture.
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
		var randix = randi_range(0, 1024)
		set_entry(randix, randi_range(1, 64), str(randix) )
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
func set_entry(item, count:int, text):
	
	## TODO: Replace with database access!!!
	if not item is int:
		item = str(item).hash()
	
	var was_found := false
	
	for slot in slot_list.get_children():
		if str(slot.item) == str(item):
			slot.count = count
			slot.text = text
			was_found = true
			break
	
	if not was_found:
		_add_entry(item, count, text)
	
	pass


func _add_entry(item, count:int, text):
	
	## Mutex to reduce chance of list corruption
	if busy:
		await busy_ended
	busy = true
	
	## Create the item slot
	var entry = INVENTORY_SLOT.instantiate()
	entry.item = item
	entry.count = count
	entry.text = text
	slot_list.add_child(entry)
	entry._update_labels()
	
	_sort_items()
	
	busy = false
	busy_ended.emit()


func _sort_items():
	## Re-sort all the slots to ensure that the entry is in the correct position
	var sorted_nodes := slot_list.get_children().duplicate()
	sorted_nodes.sort_custom(_slot_custom_sort)
	
	for node in slot_list.get_children():
		slot_list.remove_child(node)
	
	for node in sorted_nodes:
		slot_list.add_child(node)
	
	var list_size = slot_list.get_children().size()
	
	## Have the neighbors properly assigned, so if the overall display fails, 
	## the keyboard input still works.
	for node in slot_list.get_children():
		
		node.focus_next = self.focus_next
		node.focus_previous = self.focus_previous
		
		var node_index = slot_list.get_children().find(node)
		var neighbor
		
		if node_index > 0:
			neighbor = slot_list.get_children()[node_index-1]
		else:
			neighbor = slot_list.get_children()[-1]
		node.focus_neighbor_top = neighbor.get_path()
		neighbor.focus_neighbor_bottom = node.get_path()
		
		if node_index + 1 < slot_list.get_children().size():
			neighbor = slot_list.get_children()[node_index+1]
		else:
			neighbor = slot_list.get_children()[0]
		node.focus_neighbor_bottom = neighbor.get_path()
		neighbor.focus_neighbor_top = node.get_path()


# For descending order use > 0
func _slot_custom_sort(a:InventoryListItem, b:InventoryListItem):
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
