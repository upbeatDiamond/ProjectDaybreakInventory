extends Control

var umid : int = 0

@onready var item_list_display : InventoryList = $Control
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

var hori_held = 0
var vert_held = 0
var current_category := Inventory.Categories.UNSORTED


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		
		switch_category(current_category + 1)
		pass
	
	if prior_vert_held != vert_held and vert_held == VerticalQueue.NONE:
		## post the vertical movement!
		item_list_display.current_selected += 1
		pass
	
	pass


func switch_category(category):
	current_category = category % Inventory.Categories.MAX
	
	category_display.text = str("< ", Inventory.category_labels[current_category], " >")
	
	item_list_display.clear_entries()
	item_list_display.set_entry(0, 7, "Pineapple")
	item_list_display.set_entry(1, 999, "Gas Powered Stick")
	item_list_display.set_entry(2, 1, "Maddie Plush")
	item_list_display.set_entry(3, 64, "Debug Stick")
	pass


func set_umid(_umid:int=0):
	umid = _umid
	_reset_cache()


func _reset_cache():
	item_list_display.clear_entries()
	pass
