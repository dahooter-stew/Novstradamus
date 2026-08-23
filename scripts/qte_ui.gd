extends Control

@onready var key_icon_1: TextureRect = $HBoxContainer/KeyIcon1
@onready var key_icon_2: TextureRect = $HBoxContainer/KeyIcon2
@onready var key_icon_3: TextureRect = $HBoxContainer/KeyIcon3
@onready var key_icon_list: Array = [key_icon_1, key_icon_2, key_icon_3]
@onready var progress_bar: ProgressBar = $ProgressBar
