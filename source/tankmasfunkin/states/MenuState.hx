package tankmasfunkin.states;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxSpriteButton;

import ui.Controls;

import tankmasfunkin.global.Options;
import tankmasfunkin.global.Paths;

/**
 * I honestly wanted to push for a menu if this
 * got into Advent because a) it allows an excuse
 * to cram in more Tankmas tunes, and b) it does
 * tie everything together. But hey, the menu
 * still did make it in regardless!
 */

class MenuState extends flixel.FlxState
{
	public static var moveOn:Bool = false;
	public static var credits:Bool = false;
	public static var options:Bool = false;
	public static var doorClosed:FlxSprite;
	public static var doorOpen:FlxSprite;
	public static var logo:FlxSprite;
	public static var pointer:FlxSprite;
	public static var menuText:FlxText;
	public static var optionsText:FlxText;
	public static var creditsText:FlxText;
	public static var menuButton:FlxSpriteButton;
	public static var optionsButton:FlxSpriteButton;
	public static var creditsButton:FlxSpriteButton;
	public static var fillColor:FlxColor;
	public static var outlineColor:FlxColor;
	public static var selection:Int = 0;
	public static var menuY:Int;
	public static var optionsY:Int;
	public static var creditsY:Int;

	override public function create()
	{
		super.create();

		moveOn = false;
		
		// Only needs to be called once
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

		logo = new FlxSprite(0, 20, Paths.image('ui/menu/title'));
		logo.screenCenter(X);
		add(logo);

		menuText = new FlxText(200, 175, 0, "Play");
		optionsText = new FlxText(200, 200, 0, "Options");
		creditsText = new FlxText(200, 225, 0, "Credits");
		menuButton = new FlxSpriteButton(200, 175, null, gameStartup);
		optionsButton = new FlxSpriteButton(200, 200, null, optionsMenu);
		creditsButton = new FlxSpriteButton(200, 225, null, creditsMenu);
		
		fillColor = new FlxColor();
		fillColor.setRGB(255, 109, 209);
		outlineColor = new FlxColor();
		outlineColor.setRGB(34, 29, 79);

		menuText.setFormat(Paths.font('upheaval-pro-regular'), 24, fillColor, CENTER, OUTLINE, outlineColor);
		optionsText.setFormat(Paths.font('upheaval-pro-regular'), 24, fillColor, CENTER, OUTLINE, outlineColor);
		creditsText.setFormat(Paths.font('upheaval-pro-regular'), 24, fillColor, CENTER, OUTLINE, outlineColor);

		menuText.screenCenter(X);
		optionsText.screenCenter(X);
		creditsText.screenCenter(X);
		add(menuText);
		add(optionsText);
		add(creditsText);
		
		menuButton.x = menuText.x;
		optionsButton.x = optionsText.x;
		creditsButton.x = creditsText.x;
		menuButton.makeGraphic(Std.int(menuText.width), Std.int(menuText.height), FlxColor.WHITE);
		optionsButton.makeGraphic(Std.int(optionsText.width), Std.int(optionsText.height), FlxColor.WHITE);
		creditsButton.makeGraphic(Std.int(creditsText.width), Std.int(creditsText.height), FlxColor.WHITE);
		menuButton.onOver.callback = () -> selectionFunction(true, 0);
		optionsButton.onOver.callback = () -> selectionFunction(true, 1);
		creditsButton.onOver.callback = () -> selectionFunction(true, 2);
		menuButton.onUp.sound = FlxG.sound.load(Paths.sound("gamestartup"));
		optionsButton.onUp.sound = FlxG.sound.load(Paths.sound("confirm"));
		creditsButton.onUp.sound = FlxG.sound.load(Paths.sound("confirm"));
		menuButton.alpha = 0;
		optionsButton.alpha = 0;
		creditsButton.alpha = 0;
		add(menuButton);
		add(optionsButton);
		add(creditsButton);

		menuY = Std.int(menuText.y + (menuText.height / 2) - 15);
		optionsY = Std.int(optionsText.y + (optionsText.height / 2) - 15);
		creditsY = Std.int(creditsText.y + (creditsText.height / 2) - 15);

		pointer = new FlxSprite(125, menuY, Paths.image('ui/menu/pointer'));
		add(pointer);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (Controls.justPressed.A) {
			if(selection == 0 && !moveOn && !credits && !options) gameStartup();
			else if (selection == 1 && !moveOn && !credits && !options) optionsMenu();
			else if (selection == 2 && !moveOn && !credits && !options) creditsMenu();
		}
		if (Controls.justPressed.UP || Controls.justPressed.DOWN) selectionFunction(false, Controls.justPressed.UP ? -1 : 1);

		if(selection == 0) pointer.y = menuY else if (selection == 1) pointer.y = optionsY else pointer.y = creditsY;

		if (moveOn) {
			doorOpen.alpha = 1;
			doorClosed.alpha = 0;
			menuText.alpha = 0;
			optionsText.alpha = 0;
			creditsText.alpha = 0;
			pointer.alpha = 0;
			logo.alpha = 0;
		} else {
			doorOpen.alpha = 0;
            doorClosed.alpha = 1;
            menuText.alpha = 1;
			optionsText.alpha = 1;
            creditsText.alpha = 1;
			pointer.alpha = 1;
			logo.alpha = 1;
		}
	}

	function gameStartup():Void
	{
		moveOn = true;
		FlxG.sound.play(Paths.sound('confirm2'), Options.inGameSoundVolume());
		super.openSubState(new CharSelectSubState());
	}

	function creditsMenu():Void
		{
			credits = true;
			FlxG.sound.play(Paths.sound('confirm1'), Options.inGameSoundVolume());
			super.openSubState(new CreditsSubState());
		}

	function optionsMenu():Void
		{
			options = true;
			FlxG.sound.play(Paths.sound('confirm1'), Options.inGameSoundVolume());
			super.openSubState(new OptionsSubState());
		}

	function selectionFunction(bound:Bool = false, ?selectNumber:Int = 0)
		{
			FlxG.sound.play(Paths.sound('nav'), Options.inGameSoundVolume() * 1.5);
			if(!bound) {
				if(selectNumber == -1) {
					if(selection == 0) selection = 2 else selection--;
				} else {
					if(selection == 2) selection = 0 else selection++;
				}
		} else {
			selection = selectNumber;
		}
	}
}