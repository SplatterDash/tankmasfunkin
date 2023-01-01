package;

import flixel.FlxG;
import flixel.FlxGame;

class Main extends openfl.display.Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(480, 270, BootState));
	}
}

class BootState extends flixel.FlxState
{
	override function create()
	{
		super.create();
		
		// Only needs to be called once
		Controls.init();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		Global.switchState(new tankmasfunkin.states.MenuState());
	}
}