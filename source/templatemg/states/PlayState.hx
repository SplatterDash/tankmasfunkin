package templatemg.states;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

/** 
 * PlayState.hx is where Advent will start to access your game,
 * if you would like to add a menu to your game contact George!
**/
class PlayState extends FlxState
{
	//Initialize Variables Here

	//This is the Start function
	override function create()
	{
		super.create();

		final info = new FlxText();
		info.alignment = CENTER;
		info.text = "This is the play state.\n"
			+ "You're having so much fun. \n"
			+ "Press Z to continue.";
		Global.screenCenter(info);
		add(info);
	}

	/** This is where your game updates each frame */
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		//Code for your PlayState starts here
		if (Controls.justPressed.A)
			//Your failure has sent you to the GameOverState.hx
			Global.switchState(new GameOverState());
	}
}