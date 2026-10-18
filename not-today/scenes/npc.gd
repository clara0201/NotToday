extends CharacterBody2D
class_name NPC
## A non-player character that can be interacted with.

signal interacted(npc: NPC)

@export var npc_data: NPCData

var _player_in_range: bool = false

var _has_talked: bool = false

@onready var _sprite: AnimatedSprite2D = $Sprite
@onready var _interaction_prompt: Label = $InteractionPrompt
@onready var _interaction_zone: Area2D = $InteractionZone


func _ready() -> void:
	_interaction_zone.body_entered.connect(_on_player_entered)
	_interaction_zone.body_exited.connect(_on_player_exited)
	_interaction_prompt.visible = false

	if npc_data:
		_apply_npc_data()


func _unhandled_input(event: InputEvent) -> void:
	if not _player_in_range:
		return

	if event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		interacted.emit(self)
		print("emitted")


func _apply_npc_data() -> void:
	if npc_data.sprite_frames:
		_sprite.sprite_frames = npc_data.sprite_frames


func _on_player_entered(_body: Node2D) -> void:
	if _has_talked == false:
		_player_in_range = true
		_interaction_prompt.visible = true


func _on_player_exited(_body: Node2D) -> void:
	_player_in_range = false
	_interaction_prompt.visible = false
