package templatemg.states;

import flixel.text.FlxText;

import ui.Controls;

import utils.Global;

class MenuState extends flixel.FlxState
{
	override function create()
	{
		super.create();
		
		// Only needs to be called once
		Controls.init();
		
		final info = new FlxText();
		info.alignment = CENTER;
		info.text
			= "This is the menu state.\n"
			+ "This will only show in stand-alone mode.\n"
			+ "In tankmas it will just start the game.\n"
			+ "Press Z to play.";
		Global.screenCenter(info);
		add(info);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (Controls.justPressed.A)
			Global.switchState(new templatemg.states.PlayState());
	}
}