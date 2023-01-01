package tankmasfunkin.states;

import flixel.FlxSprite;
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
import tankmasfunkin.game.Highscore;
import haxe.Timer;

class GameOverState extends FlxState
{
	//Initialize Variables Here
	var finalScore:Int = PlayState.songScore;
	public var scoreText:FlxText;
	var bestScore:FlxText;
	var notThereYet:Bool = true;
	var lerpScore:Int = 0;
	var restButt:FlxButton;
	public static var newRecord:FlxText;
	public var startAdding:Bool = false;
	public static var timer:Timer;
	public static var moveOn:Bool = false;
	//hehe he said butt

	//This is the Start function
	override function create()
	{
		super.create();

		Global.camera.fade(FlxColor.BLACK, 0.5, true);
		FlxG.mouse.visible = true;
		
		FlxG.sound.playMusic(Paths.music('gameOver'), 1, true);
		scoreText = new FlxText(0, 40, 100, "FINAL SCORE:", 18);
		scoreText.setFormat(null, 18, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		Global.screenCenterX(scoreText);
		add(scoreText);

		scoreText = new FlxText(0, 90, 0, "0", 24);
		scoreText.setFormat(null, 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		scoreText.x = (Global.camera.width / 2) - (scoreText.width / 2);
		add(scoreText);
		
		bestScore = new FlxText(0, 150, 0, 'BEST as ${PlayState.charInt == 0 ? 'DD' : 'BF'}: ${Highscore.getScore(PlayState.charInt)}', 14);
		bestScore.setFormat(null, 14, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		bestScore.x = (Global.camera.width / 2) - (bestScore.width / 2);
		bestScore.alpha = 0;
		add(bestScore);

		newRecord = new FlxText(0, 170, 0, 'NEW BEST!', 11);
		newRecord.setFormat(null, 11, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		newRecord.x = (Global.camera.width / 2) - (newRecord.width / 2);
		newRecord.alpha = 0;
		add(newRecord);

		restButt = new FlxButton(0, 240, "Restart", restartGame);
		restButt.x = (Global.camera.width / 2) - (restButt.width / 2);
		restButt.exists = false;
		add(restButt);

		timer = new Timer(1000);
		timer.run = function() {
			timer.stop();
			startAdding = true;
		}
	}

	//This is where your game updates each frame
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(startAdding) {
			lerpScore = Math.round(FlxMath.lerp(lerpScore, finalScore, 0.5));

			scoreText.text = '${lerpScore}';

			if (lerpScore == finalScore && notThereYet) {
				//FlxG.sound.load(Paths.sound("finalReach"));
				notThereYet = false;

				timer = new Timer(1400);
				timer.run = function() {
					timer.stop();
					bestScore.alpha = 1;
					if(Highscore.getScore(PlayState.charInt) <= finalScore) {
						//FlxG.sound.load(Paths.sound('newBest'));
						newRecord.alpha = 1;
					};
					timer = new Timer (700);
					timer.run = function() {
						timer.stop();
						restButt.exists = true;
					}
				}
			} else if (lerpScore != finalScore) {
				//FlxG.sound.load(Paths.sound("addUp"));
				scoreText.x = (Global.camera.width / 2) - (scoreText.width / 2);
			}
			
			//Code for your GameOverState starts here
			if (Controls.justPressed.A && restButt.exists && !moveOn) restartGame;
		}
	}

	public function restartGame():Void {
		moveOn = true;
		super.openSubState(new CharSelectSubState());
	}
}