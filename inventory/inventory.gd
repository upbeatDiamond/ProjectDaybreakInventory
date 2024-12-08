extends Resource


## Defined in the database as well.
## Make sure this and the database stay in sync.
enum Categories {
	UNSORTED = 0,
	CONSUMABLES = 1, ## Food & Medicine
	EQUIPMENT = 2,   ## Useful items
	ARTIFACTS = 3,   ## Expensive/fancy items
	KEY_ITEMS = 4,   ## Non-tradable, non-consumable
	CASSETTES = 5,   ## Like HMs/TMs
	}
