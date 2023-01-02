package tankmasfunkin.states;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import tankmasfunkin.global.GameGlobal;

class PauseSubState extends MusicBeatSubstate
{
    public static var theFunny:Array<String>;

    public function new (x:Float, y:Float)
        {
            super();
            var pause = GameGlobal.getSelectionInputs("pause");

            theFunny = ["I wonder if they're still battling wilma", 'go get a glass of water ya stinky', 'chart work ahead? uh yeah, I sure hope it does', "crack moneeeey", "If I see a port of this go up on GameBanana I'mma hunt you down"];

            var bg:FlxSprite = new FlxSprite().makeGraphic(Global.width, Global.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

        var text1:FlxText = new FlxText(0, 0, 0, "PAUSED");
        text1.setFormat(null, 36, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        text1.screenCenter(X);
        add(text1);

        var text2:FlxText = new FlxText(0, 0, 400, theFunny[Math.round(Math.random()*theFunny.length)]);
        text2.setFormat(null, 18, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        text2.screenCenter(XY);
        add(text2);

        var text3:FlxText = new FlxText(0, Global.width - 40, 0, 'Press ${pause} to return to da funk.');
        text3.setFormat(null, 12, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        text3.screenCenter(X);
        add(text3);

        text1.y = -(text2.height / 2);

        FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
        }
    
    override function update(elapsed:Float)
        {
            super.update(elapsed);

            if(Controls.justPressed.PAUSE) close();
        }
}