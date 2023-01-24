package tankmasfunkin.global;

import js.html.svg.Number;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.util.FlxSignal;

// import ui.DeviceManager;
// import props.Player;
class PlayerSettings
{
	static public var numPlayers(default, null) = 0;
	static public var numAvatars(default, null) = 0;
	static public var player1(default, null):PlayerSettings;
	static public var player2(default, null):PlayerSettings;

	static public var onAvatarAdd = new FlxTypedSignal<PlayerSettings->Void>();
	static public var onAvatarRemove = new FlxTypedSignal<PlayerSettings->Void>();

	public var id(default, null):Int;

    function new(id)
        {
            this.id = id;
        }

	static public function init(?playerNum:Int):Void
	{
		if (playerNum == 2)
		{
			player2 = new PlayerSettings(0);
		}
        else {
            player1 = new PlayerSettings(0);
        }
        ++numPlayers;

        // Multiplayer code? Might look into for local two-player in minigame, but not a necessity ~SPD

		// if (numGamepads > 1)
		// {
		// 	if (player2 == null)
		// 	{
		// 		player2 = new PlayerSettings(1, None);
		// 		++numPlayers;
		// 	}

		// 	var gamepad = FlxG.gamepads.getByID(1);
		// 	if (gamepad == null)
		// 		throw 'Unexpected null gamepad. id:0';

		// 	player2.controls.addDefaultGamepad(1);
		// }
	}

	static public function reset()
	{
		player1 = null;
		player2 = null;
		numPlayers = 0;
	}
}