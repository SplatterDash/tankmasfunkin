package utils;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxTimer;

/**
 * This only exists so that the advent game can do some trickery with your game's
 * states, so that the game can be overlayed on top of the advent's state
 * @author George
 */
class Global
{
	public static var width(get, never):Int;
	inline static function get_width() return FlxG.width;
	public static var height(get, never):Int;
	inline static function get_height() return FlxG.height;
	public static var state(get, never):FlxState;
	inline static function get_state() return FlxG.state;
	
	inline public static function switchState(state:FlxState)
	{
		FlxG.switchState(state);
	}
	
	static public function resetState()
	{
		FlxG.resetState();
	}
	
	static public function cancelTweensOf(object, ?fieldPaths)
	{
		FlxTween.cancelTweensOf(object, fieldPaths);
	}
	
	inline static public function asset(path:String) return path;
	
	inline static public function screenCenterX(obj:FlxObject)
	{
		obj.x = (width - obj.width) / 2;
	}
		
	inline static public function screenCenterY(obj:FlxObject)
	{
		obj.y = (height - obj.height) / 2;
	}

	inline static public function screenCenter(obj:FlxObject, axes = FlxAxes.XY)
	{
		switch (axes)
		{
			case NONE:
			case XY:
				screenCenterX(obj);
				screenCenterY(obj);
			case X:
				screenCenterX(obj);
			case Y:
				screenCenterY(obj);
		}
	}
}