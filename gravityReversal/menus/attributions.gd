extends Control

onready var attributions = $ScrollContainer/CenterContainer/MarginContainer/VBoxContainer/Attributions

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		queue_free()






func _ready():
	attributions.text = """
	Made by Alex Haynes

	Made with the Godot Game Engine:
	https://godotengine.org/
	This is the Godot Licence:
	Copyright (c) 2007-2019 Juan Linietsky, Ariel Manzur.
	Copyright (c) 2014-2019 Godot Engine contributors (cf. AUTHORS.md)

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the \"Software\"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.


	Coin art free from from Lexassets:
	 https://www.gamedevmarket.net/member/Lexassets/

	Missile from:
	https://craftpix.net/freebies/free-space-shooter-game-objects/

	Space backgrounds from:
	https://dinvstudio.itch.io/dynamic-space-background-lite-free

	Bomb:
	\"Free Game Items Pack #2\" Olga Bikmullina (http://ahninniah.graphics) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/

	Skull:
		Designed by Alvaro_cabrera / Freepik
		www.freepik.com

	Additional sound effects from https://www.zapsplat.com

	Music:
		Reusenoise  (DNB Mix) by spinningmerkaba (c) copyright 2017 Licensed under a Creative Commons Attribution (3.0) license. http://dig.ccmixter.org/files/jlbrock44/56531

		\"Let\'s rock\", \"Ultimatum\", \"PM_ATG_3_110BPM_B\", and \"PM_ATG_3_110BPM_E\" from https://www.zapsplat.com/

	Gems from https://www.kenney.nl/assets/platformer-pack-redux

	Robot main character from: https://opengameart.org/content/the-robot-free-sprite

	Buzz saw sound from TableSawBuzz-SoundBible.com-1560233300_LOOP.wav: original by Mike Koenig from http://soundbible.com/1100-Table-Saw-Buzz.html

	Yahoo sound by  Jarred Panganiban, from http://soundbible.com/1412-Yahoo.html

	Shooting star sound by Mike Koenig, from http://soundbible.com/1744-Shooting-Star.html

	"""

