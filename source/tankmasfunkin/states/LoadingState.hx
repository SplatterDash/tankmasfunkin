package tankmasfunkin.states;

import lime.app.Promise;
import lime.app.Future;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

class LoadingState extends MusicBeatState
{
    inline static var MIN_TIME = 1.0;
	
	var target:FlxState;
	var stopMusic = false;

    function new(target:FlxState, stopMusic:Bool)
        {
            super();
            this.target = target;
            this.stopMusic = stopMusic;
        }
        inline static public function loadAndSwitchState(target:FlxState, stopMusic = false)
            {
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