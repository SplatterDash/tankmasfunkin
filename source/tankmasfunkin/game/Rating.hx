package tankmasfunkin.game;

/**DA RATING STUFF
 * 
 * Basically this was a from-scratch rating system
 * that I created out of inspiration from engines
 * that have rating systems. Only, instead of FC,
 * MFC, etc, this uses a letter system in a similar
 * way that Sonic games use letter systems.
 * 
 * The only way to get a rating of "penis" is to
 * miss more than you hit, or in other words get a
 * negative score. I wouldn't recommend it.
 */
class Rating {
    public static var ratingMap:Map<String, String> = [
         '400000' => "S"
        ,'320000' => "A"
        ,'240000' => "B"
        ,'160000' => "C"
        ,'80000' => "D"
        ,'0' => "F"
        ,'-99999999999' => "penis."
    ];

    public static function getRating(score:Float):String {
        var output:Array<String> = new Array<String>();
        for(value in ratingMap.keys()) {
            if(score >= Std.parseFloat(value)) output.push(ratingMap.get(value));
        }
        trace(output);
        return output[output.length >= 2 ? output.length - 2 : 0];
    }

    private static var perRating:Map<String, Int> = [
          'sweet' => 0
        , 'nice' => 0
        , 'naughty' => 0
        , 'grinchy' => 0
    ];

    public static function addRatingAmount(rating:String) {
        if(rating != 'sweet' && rating != 'nice' && rating != 'naughty' && rating != 'grinchy') throw 'Unexpected item in rating area. Please remove your ${rating}.';
        else {
            var rateInt:Int = perRating.get(rating);
            perRating.set(rating, rateInt + 1);
            trace(perRating.get(rating));
        }
    }

    public static function getRatingAmount(rating:String):Int {
        if(rating != 'sweet' && rating != 'nice' && rating != 'naughty' && rating != 'grinchy') throw 'Unexpected item in rating area. Please remove your ${rating}.';
        else return perRating.get(rating);
    }

    public static function resetRatingAmount() {
        for (key in perRating.keys()) perRating.set(key, 0);
    }

    public static function getRatings():Array<String> {
        var ratingArray:Array<String> = new Array<String>();
        for(key in perRating.keys()) ratingArray.push(key);
        return ratingArray;
    }
}