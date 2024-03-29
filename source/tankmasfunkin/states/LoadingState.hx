package tankmasfunkin.states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import tankmasfunkin.global.GameGlobal;
import tankmasfunkin.global.Options;
import tankmasfunkin.global.Paths;

/**
 * One of the biggest lies ever told in this
 * game is that this isn't actually a loading
 * screen. It's a phony loading screen trying
 * to give the eyes something to look at while
 * nothing happens. I'm not joking. Otherwise
 * it'd just go directly to the song, and that's
 * no fun.
 */
class LoadingState extends MusicBeatState
{
    inline static var MIN_TIME = 5.0;
	
	var target:FlxState;
	var stopMusic = false;

    public function new(target:FlxState, stopMusic:Bool)
        {
            super();
            this.target = target;
            this.stopMusic = stopMusic;
        }

    override function create()
        {
            var black = GameGlobal.getColor('black');
            var white = GameGlobal.getColor('white');

            var pause = GameGlobal.getSelectionInputs(null, Action.PAUSE);
            var nav = GameGlobal.getSelectionInputs("navigation");
            FlxG.sound.play(Paths.sound('confirm3'), Options.inGameSoundVolume());

            var loadingBG:FlxSprite = new FlxSprite();
            loadingBG.frames = Paths.getSparrowAtlas('ui/loadingBG');
            loadingBG.animation.addByPrefix('run', 'Loading Candy Cane Swirl', 12, true);
            loadingBG.antialiasing = false;
            loadingBG.screenCenter();
            add(loadingBG);

            var loadingText:FlxText = new FlxText (0, -15, 0, "Loading...");
            loadingText.setFormat(Paths.font('upheaval-pro-regular'), 50, white, CENTER, OUTLINE, black);
            loadingText.screenCenter(XY);
            add(loadingText);

            var directionText:FlxText = new FlxText(0, Global.height, 460, Options.getUiOption('botplay') ? 'Currently playing in Botplay mode\nPause: ${pause}' : 'Character controls: ${nav}\nPause: ${pause}');
            directionText.setFormat(Paths.font('upheaval-pro-regular'), 14, white, CENTER, OUTLINE, black);
            directionText.screenCenter(X);
            directionText.y = Global.height - (directionText.height + 10);
            add(directionText);

            var newY = loadingText.y + 30;
            
            loadingBG.animation.play('run', true);

            FlxTween.tween(loadingText, {y: newY}, 2, {ease: FlxEase.quartInOut, type: FlxTweenType.PINGPONG});

            new FlxTimer().start(MIN_TIME, onComplete);
        }
    override public function update(elapsed:Float)
        {
            super.update(elapsed);

            if (stopMusic && FlxG.sound.music != null)
                FlxG.sound.music.stop();
        }

    function onComplete(timer:FlxTimer)
        {
            Global.switchState(target);
        }
}