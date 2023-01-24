package tankmasfunkin.states;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import openfl.events.AsyncErrorEvent;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import flixel.FlxSubState;
import tankmasfunkin.global.Paths;
import tankmasfunkin.global.Options;
import tankmasfunkin.global.APIData;
import tankmasfunkin.global.NGio;

private typedef PlayStatusData = { code:String, duration:Float, position:Float, speed:Float };

/**Coding this was a pain in the balls for one
 * reason alone: the VCR video overlay. I
 * had to reference off a couple of sources,
 * including Tankmas 2022's source and the
 * source of the Tricky mod, to pull this
 * thing together.
 * 
 * How it works:
 *  -In PlayState.hx, the variable 
 * "negativeCombo" gets added to when a note
 * is missed and the player makes no attempt to
 * hit it.
 *  -Every time a player makes a keystroke, that
 * combo resets.
 *  -If the combo hits 100, 200 or 300, it
 * auto-pauses the game and comes to this
 * substate.
 *  -If the combo hits 300, it automatically
 * launches the player back to the main menu
 * once the clip is complete.
 * 
 * I considered removing the Play button if the
 * player gets kicked back into that screen
 * by hitting the 300 combo mark, but I'm not
 * gonna be that mean this time LOL
 */

class AFKSubState extends FlxSubState {
    public var comboInteger:Int = 100;
	public var netStream:NetStream;
	public var video:Video;
    public var videoEnded:Bool = false;
    public var played:Bool = true;

    public function new (comboInt:Int) {
        this.comboInteger = comboInt;
        super();

        video = new Video();

        var netConnection = new NetConnection();
		netConnection.connect (null);
		
		netStream = new NetStream (netConnection);
		netStream.client = { onMetaData: onMetaData, onPlayStatus: onPlayStatus };
		netStream.addEventListener (AsyncErrorEvent.ASYNC_ERROR, netStream_onAsyncError);

        netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, (e)->trace("error loading video"));
        netConnection.addEventListener(NetStatusEvent.NET_STATUS,
            function onNetStatus(event)
            {
                trace("net status:" + haxe.Json.stringify(event.info));
                if (event.info.code == "NetStream.Play.Complete")
                    videoEnded = true;
            }
        );
        FlxG.stage.addChild(video);
		netStream.play('assets/data/vcr.mp4');
        FlxG.sound.play(Paths.sound('scratch'), Options.inGameSoundVolume());
        FlxG.sound.play(Paths.sound('vhspause'), Options.inGameSoundVolume());
        if(comboInteger == 3) {
            var strikeThree:FlxSound = FlxG.sound.play(Paths.sound('afk3'), Options.inGameSoundVolume());
            strikeThree.onComplete = function() {
                NGio.unlockMedal(APIData.afkMedal);
                netStream.dispose();
                FlxG.stage.removeChild(video);
                video.visible = false;
                FlxG.sound.play(Paths.sound('vhspause'), Options.inGameSoundVolume());
                Global.switchState(new MenuState());
                close();
            }
        } else {
            var afkSound:FlxSound = comboInteger == 2 ? FlxG.sound.play(Paths.sound('afk2'), Options.inGameSoundVolume()) : FlxG.sound.play(Paths.sound('afk1'), Options.inGameSoundVolume());
            afkSound.onComplete = function() {
                netStream.dispose();
                FlxG.sound.play(Paths.sound('vhspause'), Options.inGameSoundVolume());
                close();
            };
        }
    }

    public function netStream_onAsyncError (event:AsyncErrorEvent):Void {
		
		trace ("Error loading video: " + event.toString());
		
	}

    public function onMetaData (metaData:Dynamic) {
		
		video.attachNetStream (netStream);
		video.alpha = 0.8;
		video.width = FlxG.width * 2;
		video.height = FlxG.height * 2;
	}

    public function netConnection_onNetStatus (event:NetStatusEvent):Void {
        trace (event.info.code);
    }

    function onPlayStatus(data:PlayStatusData)
        {
            //get to do nothing because I need this for some reason LOLE
        }
}