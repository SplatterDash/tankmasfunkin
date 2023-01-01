package tankmasfunkin.game;

import js.lib.Int16Array;
import flixel.FlxG;

class Highscore
{
    public static var songScores:Map<String, Int> = new Map<String, Int>();

    public static function saveScore(char:Int = 0, score:Int = 0):Void
        {
            var daChar:String = formatSong(char);

            // #if !switch
            // tankmasfunkin.data.NGio.postScore(score, daChar);
            // #end
    
            if (songScores.exists(daChar))
            {
                if (songScores.get(daChar) < score)
                    setScore(daChar, score);
            }
            else
                setScore(daChar, score);
        }
        /**
         * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
         */
        static function setScore(charName:String, score:Int):Void
        {
            // Reminder that I don't need to format this song, it should come formatted!
            songScores.set(charName, score);
            FlxG.save.data.songScores = songScores;
            FlxG.save.flush();
        }
        
        public static function getScore(char:Int):Int
        {
            if (!songScores.exists(formatSong(char)))
                setScore(formatSong(char), 0);
    
            return songScores.get(formatSong(char));
        }

        public static function formatSong(char:Int):String
            {    
                var daName:String = ''; 
                   
                 if (char == 0)
                     daName = 'DD';
                 else if (char == 1)
                     daName = 'BF';
        
                return daName;
            }

        public static function load():Void
        {
            if (FlxG.save.data.songScores != null)
            {
                songScores = FlxG.save.data.songScores;
            }
        }
}