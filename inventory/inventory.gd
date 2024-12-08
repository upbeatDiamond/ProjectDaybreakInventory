extends Resource
class_name Inventory

## Defined in the database as well.
## Make sure this and the database stay in sync.
enum Categories {
	UNSORTED = 0,
	CONSUMABLES = 1, ## Food & Medicine
	EQUIPMENT = 2,   ## Useful items
	ARTIFACTS = 3,   ## Expensive/fancy items
	KEY_ITEMS = 4,   ## Non-tradable, non-consumable
	CASSETTES = 5,   ## Like HMs/TMs
	MAX, ## value might change; used for modulo arithmetic
	}

static var category_labels := {
	Categories.UNSORTED : "Misc.",
	Categories.CONSUMABLES : "Consumable",
	Categories.EQUIPMENT : "Equipment",
	Categories.ARTIFACTS : "Artifacts",
	Categories.KEY_ITEMS : "Key Items",
	Categories.CASSETTES : "Cassettes",
}
