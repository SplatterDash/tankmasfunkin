package tankmasfunkin.states;

import tankmasfunkin.game.Rating;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxAxes;
import flixel.ui.FlxButton;
import flixel.FlxState;
import flixel.math.FlxMath;
import tankmasfunkin.states.PlayState;
import tankmasfunkin.global.Paths;
import tankmasfunkin.global.Options;
import tankmasfunkin.global.NGio;
import tankmasfunkin.global.APIData;
import tankmasfunkin.global.GameGlobal;
import tankmasfunkin.game.Highscore;
import tankmasfunkin.game.Rating;
import flixel.util.FlxTimer;

/**
 * I didn't know where else to end this, despite this
 * being in (I think?) the standAloneSource file.
 * It doesn't allow you to go back to the menu
 * because it's a Tankmas game and most don't
 * usually bring you back to the main menu after you
 * beat the game, they just offer an option to
 * restart the game again.
 */

class BotplayGameOverState extends FlxState
{
	//Initialize Variables Here
	var finalScore:Int = PlayState.songScore;
	var finalMiss:Int = PlayState.comboBreak;
	public var headingText:FlxText;
	public var ratings:Array<String>;
	public var statText:FlxText;
	public var statRateText:FlxText;
	public var bg:FlxSprite;
	public var mainAnim:FlxSprite;
	public var gunAnim:FlxSprite;
	public var scoreText:FlxText;
	public var finalScoreText:FlxText;
	public var ratingText:FlxText;
	public var ratingRate:String;
	public var finalRatingText:FlxText;
	public var sympathyText:FlxText;
	var bestScore:FlxText;
	var notThereYet:Bool = true;
	var lerpScore:Int = 0;
	var restButt:FlxButton;
		//hehe he said butt
	var menuButt:FlxButton;
		//hehe he said butt again
	public static var newRecord:FlxText;
	public var statInt:Int = 1;
	public var startAdding:Bool = false;
	public static var timer:FlxTimer;
	public static var statTimer:FlxTimer;
	public static var moveOn:Bool = false;

	public var fill:FlxColor = GameGlobal.getColor('fill');
	public var outline:FlxColor = GameGlobal.getColor('outline');

	//This is the Start function
	override function create()
	{
		super.create();

		var bgColor = GameGlobal.getColor('black');

		Global.camera.fade(FlxColor.BLACK, 1.3, true);
		FlxG.mouse.visible = true;

		ratings = Rating.getRatings();

		bg = new FlxSprite(0, 0);
		bg.makeGraphic(480, 270, bgColor);
		add(bg);

		headingText = new FlxText(0, 20, "BOTPLAY COMPLETE");
		headingText.setFormat(Paths.font('upheaval-pro-regular'), 27, fill, CENTER, OUTLINE, outline);
		headingText.screenCenter(X);
		add(headingText);

		statText = new FlxText(70, 80, 0, 'See how to do it?\nNow hit Restart or press ${GameGlobal.getSelectionInputs(null, Action.A)} to\nplay it for yourself!');
		statText.setFormat(Paths.font('upheaval-pro-regular'), 21, fill, CENTER, OUTLINE, outline);
        statText.screenCenter(XY);
		add(statText);

		restButt = new FlxButton(0, 240, "Restart", restartGame);
		restButt.screenCenter(X);
		restButt.x -= 40;
		add(restButt);

		menuButt = new FlxButton(0, 240, "Main Menu", function() { Global.switchState(new tankmasfunkin.states.MenuState()); });
		menuButt.screenCenter(X);
		menuButt.x += 40;
		add(menuButt);

        FlxG.sound.playMusic(Paths.music('gameOver'), Options.inGameMusicVolume(), true);
	}

	//This is where your game updates each frame
	override function update(elapsed:Float)
	{
		super.update(elapsed);			
		if (Controls.justPressed.A && restButt.exists && !moveOn) restartGame;
	}

	public function restartGame():Void {
		FlxG.sound.play(Paths.sound('confirm2'), Options.inGameSoundVolume());
        Options.setUiOption('botplay', false);
		moveOn = true;
		super.openSubState(new CharSelectSubState());
	}
}