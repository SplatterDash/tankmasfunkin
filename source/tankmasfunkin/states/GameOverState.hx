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

class GameOverState extends FlxState
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

		headingText = new FlxText(0, 20, "SONG COMPLETE");
		headingText.setFormat(Paths.font('upheaval-pro-regular'), 27, fill, CENTER, OUTLINE, outline);
		headingText.screenCenter(X);
		headingText.alpha = 0;

		statText = new FlxText(70, 80, 0, ratings[0]);
		statText.setFormat(Paths.font('upheaval-pro-regular'), 21, fill, LEFT, OUTLINE, outline);
		statText.alpha = 0;
		for (i in 1...ratings.length) statText.text += '\n\n${ratings[i]}';
		statText.text += '\n\nCombo Breaks';

		statRateText = new FlxText(370, 80, 0, '${Rating.getRatingAmount(ratings[0])}');
		statRateText.setFormat(Paths.font('upheaval-pro-regular'), 21, fill, LEFT, OUTLINE, outline);
		statRateText.alpha = 0;
		statRateText.x -= statRateText.width;

		mainAnim = new FlxSprite(0, 0);
		mainAnim.frames = Paths.getSparrowAtlas('ui/tankmasfinal1');
		mainAnim.animation.addByPrefix('run', "So This Is The Credits", 12, true);
		add(mainAnim);

		gunAnim = new FlxSprite(0, 0);
		gunAnim.frames = Paths.getSparrowAtlas('ui/tankmasfinal2');
		gunAnim.animation.addByPrefix('run', "He Got A Glock In His Rari", 12, true);
		gunAnim.alpha = 0;
		add(gunAnim);

		add(headingText);
		add(statRateText);
		add(statText);
		
		FlxG.sound.playMusic(Paths.music('gameOver'), Options.inGameMusicVolume(), true);
		scoreText = new FlxText(0, 63, 100, "FINAL SCORE:");
		scoreText.setFormat(Paths.font('upheaval-pro-regular'), 18, fill, CENTER, OUTLINE, outline);
		scoreText.screenCenter(X);
		scoreText.alpha = 0;
		add(scoreText);

		finalScoreText = new FlxText(0, 90, 0, "0");
		finalScoreText.setFormat(Paths.font('upheaval-pro-regular'), 24, fill, CENTER, OUTLINE, outline);
		finalScoreText.screenCenter(X);
		finalScoreText.alpha = 0;
		add(finalScoreText);

		ratingText = new FlxText(0, 130, 0, "Final Rating:");
		ratingText.setFormat(Paths.font('upheaval-pro-regular'), 18, fill, CENTER, OUTLINE, outline);
		ratingText.screenCenter(X);
		ratingText.alpha = 0;
		add(ratingText);

		ratingRate = Rating.getRating(Std.parseFloat(Std.string(finalScore)));

		finalRatingText = new FlxText(0, 128 + ratingText.height, 0, ratingRate);
		finalRatingText.setFormat(Paths.font('upheaval-pro-regular'), ratingRate == 'penis.' ? 30 : 24, fill, CENTER, OUTLINE, outline);
		if(ratingRate == 'penis.') finalRatingText.screenCenter() else finalRatingText.screenCenter(X);
		finalRatingText.alpha = 0;
		add(finalRatingText);

		sympathyText = new FlxText(0, finalRatingText.y + finalRatingText.height, 0, "(don't actually though <3)");
		sympathyText.setFormat(Paths.font('upheaval-pro-regular'), 18, fill, CENTER, OUTLINE, outline);
		sympathyText.screenCenter(X);
		sympathyText.alpha = 0;
		add(sympathyText);
		
		bestScore = new FlxText(0, 180, 0, 'BEST as ${PlayState.charInt == 0 ? 'DD' : 'BF'}: ${Highscore.getScore(PlayState.charInt)}');
		if (Options.getUiOption('practice')) bestScore.text = "Well done!\nNow try to complete it without practice mode!";
		bestScore.setFormat(Paths.font('upheaval-pro-regular'), 17, fill, CENTER, OUTLINE, outline);
		bestScore.screenCenter(X);
		bestScore.alpha = 0;
		add(bestScore);

		newRecord = new FlxText(0, 195, 0, 'NEW BEST!');
		newRecord.setFormat(Paths.font('upheaval-pro-regular'), 14, fill, CENTER, OUTLINE, outline);
		newRecord.screenCenter(X);
		newRecord.alpha = 0;
		add(newRecord);

		restButt = new FlxButton(0, 240, "Restart", restartGame);
		restButt.screenCenter(X);
		restButt.x -= 40;
		restButt.exists = false;
		add(restButt);

		menuButt = new FlxButton(0, 240, "Main Menu", function() { Global.switchState(new tankmasfunkin.states.MenuState()); });
		menuButt.screenCenter(X);
		menuButt.x += 40;
		menuButt.exists = false;
		add(menuButt);

		mainAnim.animation.play('run', true);
		gunAnim.animation.play('run', true);

		timer = new FlxTimer().start(3.3, function(tmr:FlxTimer) {
			FlxTween.tween(gunAnim, {alpha: 1}, 1.2, {type: FlxTweenType.PERSIST});
			timer = new FlxTimer().start(3.6, function(tmr:FlxTimer) {
				FlxTween.tween(gunAnim, {alpha: 0.6}, 1.2, {type: FlxTweenType.PERSIST});
				FlxTween.tween(mainAnim, {alpha: 0.6}, 1.2, {type: FlxTweenType.PERSIST});
				FlxTween.tween(bg, {alpha: 0.6}, 1.2, {type: FlxTweenType.PERSIST});
				FlxTween.tween(headingText, {alpha: 1}, 1.2, {type: FlxTweenType.PERSIST});
				FlxTween.tween(statText, {alpha: 1}, 1.2, {type: FlxTweenType.PERSIST});
				timer = new FlxTimer().start(1.2, function(tmr:FlxTimer) {
					statRateText.alpha = 1;
					statTimer = new FlxTimer().start(0.5, function(tmr:FlxTimer) {
						FlxG.sound.play(Paths.sound("addup"), Options.inGameSoundVolume());
						statRateText.text += '\n\n${Rating.getRatingAmount(ratings[statInt])}';
						statInt++;
					}, ratings.length - 1);
					timer = new FlxTimer().start(0.5 * (ratings.length), function(tmr:FlxTimer) {
						statRateText.text += '\n\n$finalMiss';
						FlxG.sound.play(Paths.sound("addcomplete"), Options.inGameSoundVolume());
						timer = new FlxTimer().start(1.2, function(tmr:FlxTimer) {
							FlxTween.tween(statRateText, {alpha: 0}, 1.2, {type: FlxTweenType.PERSIST});
							FlxTween.tween(statText, {alpha: 0}, 1.2, {type: FlxTweenType.PERSIST});
							FlxTween.tween(scoreText, {alpha: 1}, 1.2, {type: FlxTweenType.PERSIST});
							FlxTween.tween(finalScoreText, {alpha: 1}, 1.2, {type: FlxTweenType.PERSIST, onComplete: function(twn:FlxTween) { startAdding = true; }});
						}, 1);
					}, 1);
				}, 1);
			}, 1);
		}, 1);
	}

	//This is where your game updates each frame
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(startAdding) {
			 if(finalScore < 0) {
			 	finalScoreText.text = 'suck my';
				 finalScoreText.screenCenter(X);
			  } else {
				lerpScore = Math.round(FlxMath.lerp(lerpScore, finalScore, 0.5));
				finalScoreText.text = '${lerpScore}';
				finalScoreText.screenCenter(X);
			 }

			if ((lerpScore == finalScore || finalScoreText.text == 'suck my') && notThereYet) {
				FlxG.sound.play(Paths.sound("addcomplete"), Options.inGameSoundVolume());
				notThereYet = false;

				timer = new FlxTimer().start(1.4, function(tmr:FlxTimer) {
					ratingText.alpha = 1;
					timer = new FlxTimer().start(1.2, function(tmr:FlxTimer) {
						finalRatingText.alpha = 1;
						if(getRatingSound() != null) FlxG.sound.play(Paths.sound(getRatingSound()), Options.inGameSoundVolume() * (finalScore < 0 ? 0.8 : 1));
						if(finalScore < 0) {
							FlxG.sound.music.volume = 0;
							ratingText.alpha = 0;
							timer = new FlxTimer().start(1, function(tmr:FlxTimer) {
								FlxG.sound.play(Paths.sound('keepdachange'), Options.inGameSoundVolume());
								timer = new FlxTimer().start(0.7, function(tmr:FlxTimer) {
									sympathyText.alpha = 1;
								}, 1);
							}, 1);
						} else if(ratingRate == 'S') NGio.unlockMedal(PlayState.charInt == 0 ? APIData.ddSMedal : APIData.bfSMedal);
						timer = new FlxTimer().start(1.3 + (finalScore < 0 ? 2 : 0), function(tmr:FlxTimer) {
							FlxG.sound.music.volume = Options.inGameMusicVolume();
							bestScore.alpha = 1;
							if(Highscore.getScore(PlayState.charInt) <= finalScore && finalScore > 0 && !Options.getUiOption('practice')) {
								FlxG.sound.play(Paths.sound('newbest'), Options.inGameSoundVolume());
								newRecord.alpha = 1;
								NGio.unlockMedal(PlayState.charInt == 0 ? APIData.ddMedal : APIData.bfMedal);
							};
							if(finalScore >= 0 && !Options.getUiOption('practice')) Highscore.saveScore(PlayState.charInt, finalScore);
							timer = new FlxTimer().start(1.5, function(tmr:FlxTimer) {
								restButt.exists = true;
								menuButt.exists = true;
							}, 1);
						}, 1);
					}, 1);
				}, 1);
			} else if (lerpScore != finalScore && finalScoreText.text != 'suck my') {
				FlxG.sound.play(Paths.sound("addup"), Options.inGameSoundVolume());
				finalScoreText.screenCenter(X);
			}
			
			if (Controls.justPressed.A && restButt.exists && !moveOn) restartGame;
		}
	}

	public function restartGame():Void {
		FlxG.sound.play(Paths.sound('confirm2'), Options.inGameSoundVolume());
		moveOn = true;
		super.openSubState(new CharSelectSubState());
	}

	public function getRatingSound():String {
		return switch(ratingRate) {
			case 'penis.': "fart";
			case 'C', 'B': "confirm1";
			case 'A': 'confirm2';
			case 'S': 'confirm3';
			default: null;
		}
	}
}