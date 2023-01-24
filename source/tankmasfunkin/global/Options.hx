package tankmasfunkin.global;

/**
 * This is mainly here to centralize the volume
 * settings across the game, which can be
 * tweaked in the Options menu. I also slipped
 * the score values in here to keep things tidy
 * and refer to them in the Options menu as well
 * as in PlayState.
 */

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
         'grinchy' => [50, 0]
        ,'naughty' => [100, 1]
        ,'nice'    => [200, 2]
        ,'sweet'   => [350, 3]
    ];

}