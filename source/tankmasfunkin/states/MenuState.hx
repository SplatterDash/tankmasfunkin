package tankmasfunkin.states;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;

import ui.Controls;

import utils.Global;
import tankmasfunkin.global.GameGlobal;
import tankmasfunkin.states.PlayState;
import tankmasfunkin.game.Highscore;
import tankmasfunkin.global.Paths;
import tankmasfunkin.game.Song;

class MenuState extends flixel.FlxState
{
	public static var moveOn:Bool = false;
	public static var credits:Bool = false;
	public static var doorClosed:FlxSprite;
	public static var doorOpen:FlxSprite;

	override public function create()
	{
		super.create();
		
		// Only needs to be called once
		Controls.init();
		GameGlobal.initialized = false;
		GameGlobal.init();
		FlxG.sound.playMusic(Paths.music('mainMenu'));

		doorClosed = new FlxSprite(0, 0, Paths.image('ui/menu/doorclosed'));
		doorClosed.setSize(Std.int(doorClosed.width * 2), Std.int(doorClosed.height * 2));
		doorClosed.updateHitbox();
		add(doorClosed);

		doorOpen = new FlxSprite(0, 0, Paths.image('ui/menu/dooropen'));
		doorOpen.alpha = 0;
		doorOpen.setSize(Std.int(doorOpen.width * 2), Std.int(doorOpen.height * 2));
		doorOpen.updateHitbox();
		add(doorOpen);

		var menuButton:FlxButton = new FlxButton(200, 0, "Play", gameStartup);
		var creditsButton:FlxButton = new FlxButton(200, 200, "Credits", creditsMenu);
		menuButton.screenCenter(Y);
		menuButton.onUp.sound = FlxG.sound.load(Paths.sound("gamestartup"));
		creditsButton.onUp.sound = FlxG.sound.load(Paths.sound("confirm"));
		add(menuButton);
		add(creditsButton);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (Controls.justPressed.A && !moveOn && !credits) gameStartup();
	}

	function gameStartup():Void
	{
		doorOpen.alpha = 1;
		doorClosed.alpha = 0;
		moveOn = true;
		super.openSubState(new CharSelectSubState());
	}

	function creditsMenu():Void
		{
			credits = true;
			super.openSubState(new CreditsSubState());
		}
}