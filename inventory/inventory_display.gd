extends Control

var umid : int = 0

@onready var item_list_display : InventoryList = $InventoryList
@onready var category_display : Label = $CategoryLabel

enum HorizontalQueue {
	NONE = 0,
	LEFT,
	RIGHT,
	LEFT_RIGHT,
}

enum VerticalQueue {
	NONE = 0,
	UP,
	DOWN,
	UP_DOWN,
}

## User should hold down, and after a second, it scrolls through automatically
const HORI_HELD_COOLDOWN_DURATION := 1.0
var hori_held = 0
var hori_held_cooldown = HORI_HELD_COOLDOWN_DURATION
var vert_held = 0
var current_category := Inventory.Categories.UNSORTED

var inventory : Inventory


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalDatabase.reset_save_file()
	inventory = Inventory.new(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var prior_hori_held = hori_held
	var prior_vert_held = vert_held
	hori_held = HorizontalQueue.NONE
	vert_held = HorizontalQueue.NONE
	
	if Input.is_action_pressed("ui_left"):
		hori_held = HorizontalQueue.LEFT
	if Input.is_action_pressed("ui_right"):
		match hori_held:
			HorizontalQueue.NONE:
				hori_held = HorizontalQueue.RIGHT
			HorizontalQueue.LEFT:
				hori_held = HorizontalQueue.LEFT_RIGHT
	
	if Input.is_action_pressed("ui_up"):
		vert_held = VerticalQueue.UP
	if Input.is_action_pressed("ui_down"):
		match vert_held:
			VerticalQueue.NONE:
				vert_held = VerticalQueue.DOWN
			VerticalQueue.UP:
				vert_held = VerticalQueue.UP_DOWN
	
	if prior_hori_held != hori_held and hori_held == HorizontalQueue.NONE:
		## post the horizontal movement!
		if prior_hori_held == HorizontalQueue.LEFT:
			switch_category(current_category - 1)
		elif prior_hori_held == HorizontalQueue.RIGHT:
			switch_category(current_category + 1)
		pass
	
	#if prior_vert_held != vert_held and vert_held == VerticalQueue.NONE:
		### post the vertical movement!
		#item_list_display.current_selected += 1
		#pass
	
	pass


func switch_category(category):
	current_category = posmod(category, Inventory.Categories.MAX)
	
	
	category_display.text = str("< ", Inventory.category_labels[current_category], " >")
	
	var category_items = inventory.get_items_in_category(category)
	
	await _reset_cache()
	for item in category_items:
		item_list_display.set_entry( str(item["item"]).to_int(), str(item["quantity"]).to_int(), item["tr_key"] )
	#item_list_display.set_entry(1, 999, "Gas Powered Stick")
	#item_list_display.set_entry(2, 1, "Maddie Plush")
	#item_list_display.set_entry(3, 64, "Debug Stick")
	
	pass


func set_umid(_umid:int=0):
	umid = _umid
	_reset_cache()


func _reset_cache():
	await item_list_display.clear_entries()
	#await get_tree().process_frame
	pass
