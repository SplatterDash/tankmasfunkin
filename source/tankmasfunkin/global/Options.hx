package tankmasfunkin.global;

/**
 * This is mainly here to centralize the volume
 * settings across the game, which can be
 * tweaked in the Options menu. I also slipped
 * the score values in here to keep things tidy
 * and refer to them in the Options menu as well
 * as in PlayState.
 */

import flixel.FlxG;

class Options
{
    public static var volumeMap:Map<String, Float> = [
         "masterVolume" => 1
        ,"sfxVolume" => 1
        ,"musicVolume" => 1
    ];

    public static function inGameMusicVolume():Float {
        return volumeMap.get('musicVolume') * volumeMap.get('masterVolume');
    }

    public static function inGameSoundVolume():Float {
        return volumeMap.get('sfxVolume') * volumeMap.get('masterVolume');
    }

    public static var scoreMap:Map<String, Array<Float>> = [
         'grinchy' => [75, 0]
        ,'naughty' => [150, 1]
        ,'nice'    => [250, 2]
        ,'sweet'   => [350, 3]
    ];

    public static var ui:Map<String, Bool> = [
         "downscroll"      => false
        ,'middlescroll'    => false
        ,'hidetime'        => false
        ,'hidescore'       => false
        ,'practice'        => false
        ,'botplay'         => false
        ,'fullscreen'      => false
    ];

    public static function checkForAllOptions() {
        var uiOptionList = ['downscroll', 'middlescroll', 'hidetime', 'hidescore', 'practice', 'botplay', 'fullscreen'];
        for (option in uiOptionList) {
            if(!ui.exists(option))      ui.set(option, false);
        }
        saveUiOptions();
    }

    public static function getUiOption(option:String):Bool {
        if(!ui.exists(option)) return throw 'Option ${option} not found.' else return ui.get(option);
    }

    public static function setUiOption(option:String, value:Bool):Void {
        /*if(!ui.exists(option)) return throw 'Option ${option} not found.' else*/ ui.set(option, value);
        if(option == 'fullscreen') FlxG.fullscreen = value;
    }

    public static function saveUiOptions():Void {
        FlxG.save.data.uiOptions = ui;
        FlxG.save.flush();
    }

    public static function loadUiOptions():Void {
        ui = FlxG.save.data.uiOptions;
    }

    public static function getVolumeValue(key:String) {
        if(!volumeMap.exists(key)) return throw 'Volume setting ${key} not found.' else return volumeMap.get(key);
    }

    public static function setVolumeValue(key:String, value:Float) {
        if(!volumeMap.exists(key)) return throw 'Volume setting ${key} not found.' else return volumeMap.set(key, value);
    }

    public static function saveVolumeValues():Void {
        FlxG.save.data.volumeSettings = volumeMap;
        FlxG.save.flush();
    }

    public static function loadVolumeValues():Void {
        volumeMap = FlxG.save.data.volumeSettings;
    }
}