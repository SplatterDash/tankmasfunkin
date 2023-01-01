package tankmasfunkin.global;

import tankmasfunkin.states.PlayState;
import tankmasfunkin.states.LoadingState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flixel.system.FlxAssets.FlxShader;

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

    public static function getSelectionInputs(action:String):String
    {
        if(Controls.mode == Keys) {
            return switch (action) {
                case "navigation": "Left/Right Arrows or W/D";
                case "selection": "Z, J or Spacebar";
                case "back": "X or K";
                case "gameplay": "Arrow Keys and/or WASD";
                default: "Slam Your Face Button(c) and call for help";
            } 
        } else {
            return switch (action) {
            case "navigation": "D-Pad or Left Stick";
            case "selection": "A or X";
            case "back": "B or Y";
            case "gameplay": "D-Pad and/or Left Stick";
            default: "Slam Your Face Button(c) and call for help";
            }
        }
    }
}