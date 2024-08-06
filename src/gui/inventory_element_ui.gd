extends HBoxContainer


class_name InventoryElementUi


@onready var icon_node: TextureRect = $Icon
@onready var name_node: Label = $Name
@onready var amount_node: Label = $PanelContainer/Amount


var label: String = ""
var icon_path: String = ""
var icon_atlas : bool = false
var atlas_pos : Vector2 = Vector2.ZERO
var amount: int = 0


func _ready() -> void:
	name_node.text = label.to_upper()
	amount_node.text = str(amount)

	var texture : Texture2D = load(icon_path)

	if icon_atlas:
		var atlas_texture : AtlasTexture = AtlasTexture.new()
		atlas_texture.atlas = texture
		atlas_texture.region = Rect2(atlas_pos, Vector2(16,16))
		icon_node.texture = atlas_texture

		return

	icon_node.texture = texture
