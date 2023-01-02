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


class LoadingState extends MusicBeatState
{
    inline static var MIN_TIME = 5.0;
	
	var target:FlxState;
	var stopMusic = false;

    function new(target:FlxState, stopMusic:Bool)
        {
            super();
            this.target = target;
            this.stopMusic = stopMusic;
        }

        override function create()
            {
                var pause = GameGlobal.getSelectionInputs("pause");
                var nav = GameGlobal.getSelectionInputs("navigation");

                var loadingText:FlxText = new FlxText (0, 0, 0, "Loading...");
                loadingText.setFormat(null, 50, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
                loadingText.screenCenter(XY);
                add(loadingText);

                var directionText:FlxText = new FlxText(0, Global.height - 40, 0, 'Use ${nav} to control your character. Press ${pause} to pause.');
                directionText.setFormat(null, 15, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
                directionText.screenCenter(X);
                add(directionText);

                var newY = loadingText.y + 30;

                FlxTween.tween(loadingText, {y: newY}, 2, {ease: FlxEase.quartInOut, type: FlxTweenType.PINGPONG});
            }
        inline static public function loadAndSwitchState(target:FlxState, stopMusic = false)
            {
                Global.switchState(new LoadingState(target, stopMusic));
                Global.switchState(getNextState(target, stopMusic));
            }
            
            static function getNextState(target:FlxState, stopMusic = false):FlxState
            {
                #if NO_PRELOAD_ALL
                var loaded = isSoundLoaded(getSongPath())
                    && (!PlayState.SONG.needsVoices || isSoundLoaded(getVocalPath()))
                    && isLibraryLoaded("shared");
                
                if (!loaded)
                    return new LoadingState(target, stopMusic);
                #end
                if (stopMusic && FlxG.sound.music != null)
                    FlxG.sound.music.stop();
                
                return target;
            }
            
            #if NO_PRELOAD_ALL
            static function isSoundLoaded(path:String):Bool
            {
                return Assets.cache.hasSound(path);
            }
            
            static function isLibraryLoaded(library:String):Bool
            {
                return Assets.getLibrary(library) != null;
            }
            #end
}