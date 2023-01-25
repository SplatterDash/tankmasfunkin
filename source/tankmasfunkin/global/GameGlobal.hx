package tankmasfunkin.global;

import tankmasfunkin.states.PlayState;
import tankmasfunkin.states.LoadingState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.util.FlxColor;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flixel.system.FlxAssets.FlxShader;

/**
 * GameGlobal's named like this because it was
 * taken as inspiration from another Tankmas
 * 2022 minigame, Yule Duel. Some elements from
 * that minigame were utilized but then modified,
 * especially as the Options menu developed.
 * 
 * It also allowed for a really effective way
 * to include instructions and details on
 * whatever I needed to!
 */

class GameGlobal
{
    public static var initialized:Bool = false;
    public static var PlayState:PlayState;

    public static var transition:LoadingState;

    public static function init():Void
        {
            if (initialized)
                return;
            initialized = true;

            Global.camera.bgColor = FlxColor.TRANSPARENT;
            Global.camera.pixelPerfectRender = true;
            Global.camera.antialiasing = false;
            FlxSprite.defaultAntialiasing = false;

            #if STAND_ALONE
		FlxG.game.setFilters([new ShaderFilter(new FlxShader())]);
		FlxG.game.stage.quality = StageQuality.LOW;
		FlxG.resizeWindow(960, 540);
		#end
	}

    #if ADVENT
	public static function uninit()
	{
		FlxG.mouse.visible = true;
		FlxSprite.defaultAntialiasing = true;
	}
	#end

    public static function getSelectionInputs(specialAction:String, ?action:Action):String
    {
        var output:String = '';
        if(Controls.mode == Keys) {
            if (specialAction != null) switch(specialAction) {
                case "navigation", "gameplay":
                    var upKeys:Array<FlxKey> = ControlsList.keys.get(Action.UP);
                    var downKeys:Array<FlxKey> = ControlsList.keys.get(Action.DOWN);
                    var leftKeys:Array<FlxKey> = ControlsList.keys.get(Action.LEFT);
                    var rightKeys:Array<FlxKey> = ControlsList.keys.get(Action.RIGHT);

                    return output = '${InputFormatter.getKeyName(leftKeys[0])}/${InputFormatter.getKeyName(upKeys[0])}/${InputFormatter.getKeyName(downKeys[0])}/${InputFormatter.getKeyName(rightKeys[0])}, ${InputFormatter.getKeyName(leftKeys[1])}/${InputFormatter.getKeyName(upKeys[1])}/${InputFormatter.getKeyName(downKeys[1])}/${InputFormatter.getKeyName(rightKeys[1])}';

                default: return output = 'the Slam Your Face Button(c) and call for help';
            } else {
                var duoKeys = ControlsList.keys.get(action);
                var keyMain = InputFormatter.getKeyName(duoKeys[0]);
                var keyAlt = InputFormatter.getKeyName(duoKeys[1]);
                return output = '${keyMain}/${keyAlt}';
            }
        } else {
            if (specialAction != null) switch(specialAction) {
                case "navigation", "gameplay":
                    var upButtons:Array<FlxGamepadInputID> = ControlsList.buttons.get(Action.UP);
                    var downButtons:Array<FlxGamepadInputID> = ControlsList.buttons.get(Action.DOWN);
                    var leftButtons:Array<FlxGamepadInputID> = ControlsList.buttons.get(Action.LEFT);
                    var rightButtons:Array<FlxGamepadInputID> = ControlsList.buttons.get(Action.RIGHT);

                    return output = '${InputFormatter.getButtonName(leftButtons[0])}, ${InputFormatter.getButtonName(upButtons[0])}, ${InputFormatter.getButtonName(downButtons[0])}, ${InputFormatter.getButtonName(rightButtons[0])} or ${InputFormatter.getButtonName(leftButtons[1])}, ${InputFormatter.getButtonName(upButtons[1])}, ${InputFormatter.getButtonName(downButtons[1])}, ${InputFormatter.getButtonName(rightButtons[1])}';

                default: return output = 'the Slam Your Face Button(c) and call for help';
            } else {
                var duoButtons = ControlsList.buttons.get(action);
                var buttonMain = InputFormatter.getButtonName(duoButtons[0]);
                var buttonAlt = InputFormatter.getButtonName(duoButtons[1]);
                return output = '${buttonMain}/${buttonAlt}';
            }
        }
    }

    public static function getColor(name:String):FlxColor {
        var color = new FlxColor();
        switch (name)
        {
            case "fill": color.setRGB(255, 109, 209);
            case "outline": color.setRGB(34, 29, 79);
            case "black": color.setRGB(0, 0, 0);
            case "white": color.setRGB(255, 255, 255);
            default: color.setRGB(255, 0, 0);
        }
        return color;
    }
}