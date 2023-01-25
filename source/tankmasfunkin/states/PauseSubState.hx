package tankmasfunkin.states;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import tankmasfunkin.global.GameGlobal;
import tankmasfunkin.global.Paths;

/**
 * I chose not to go super fancy with the pause menu
 * because, in all honesty, I don't think it's needed
 * too much. It's a good to have, but not a
 * necessity.
 */

class PauseSubState extends MusicBeatSubstate
{
    public static var theFunny:Array<String>;

    public function new (x:Float, y:Float)
        {
            super();
            var pause = GameGlobal.getSelectionInputs(null, Action.PAUSE);
            var back = GameGlobal.getSelectionInputs(null, Action.B);

            theFunny = ["I wonder if they're still battling wilma", 'Go get a glass of water ya stinky', 'Chart work ahead? Uh yeah, I sure hope it does', "crack moneeeey", "If I see a port of this go up on GameBanana I'mma hunt you down", "NG has used necromancy to revive HenryEYES"];
            //if you see this, send me funnies

            var fill:FlxColor = GameGlobal.getColor('fill');
            var outline:FlxColor = GameGlobal.getColor('outline');

            var bg:FlxSprite = new FlxSprite(-500, -250).makeGraphic(1500, 1000, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set(0, 0);
		add(bg);

        var text1:FlxText = new FlxText(0, 0, 0, "PAUSED");
        text1.setFormat(Paths.font('upheaval-pro-regular'), 42, fill, CENTER, OUTLINE, outline);
        text1.screenCenter(X);
        text1.scrollFactor.set(0, 0);
        add(text1);

        var text2:FlxText = new FlxText(0, 0, 400, theFunny[Math.round(Math.random() * theFunny.length)]);
        text2.setFormat(Paths.font('upheaval-pro-regular'), 22, fill, CENTER, OUTLINE, outline);
        text2.screenCenter();
        text2.scrollFactor.set(0, 0);
        add(text2);

        var text3:FlxText = new FlxText(0, Global.height - 20, 0, 'Return to da funk - ${pause}\nReturn to Main Menu - ${back}');
        text3.setFormat(Paths.font('upheaval-pro-regular'), 17, fill, CENTER, OUTLINE, outline);
        text3.screenCenter(X);
        text3.scrollFactor.set(0, 0);
        add(text3);

        text1.y = -(text2.height / 2);

        FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
        }
    
    override function update(elapsed:Float)
        {
            super.update(elapsed);

            if(Controls.justPressed.PAUSE) close();
            if(Controls.justPressed.B) FlxG.switchState(new tankmasfunkin.states.MenuState());
        }
}