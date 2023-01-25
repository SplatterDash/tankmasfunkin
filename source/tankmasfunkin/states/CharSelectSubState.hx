package tankmasfunkin.states;

import tankmasfunkin.states.LoadingState;
import tankmasfunkin.states.MenuState;
import tankmasfunkin.states.PlayState;
import tankmasfunkin.game.Highscore;
import tankmasfunkin.game.Song;
import tankmasfunkin.game.Rating;
import tankmasfunkin.global.Paths;
import tankmasfunkin.global.GameGlobal;
import tankmasfunkin.global.Options;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.FlxSubState;
import flixel.FlxG;

/**Ah yes, the character selection feature.
 * 
 * I wanted to try it out to give a little more
 * playability to the game, and actually because
 * I had the idea of wanting to make this minigame
 * multiplayer using a similar system to what's
 * used in Tankmas. But I'm way too smol brain
 * for that in all honesty, so it's mainly here
 * for playability.
 * 
 * Whatever the player chooses here becomes
 * `charInt` in PlayState.hx, which sends the
 * necessary signals to which character the
 * player's playing as.
 */

class CharSelectSubState extends FlxSubState {
    public var curSelect:Int = 1;
    public var panelRec:FlxSprite;
    public var selectionText:FlxText;
    public var ddImage:FlxSprite;
    public var bfImage:FlxSprite;
    public var ddText:FlxText;
    public var bfText:FlxText;
    public var directionText:FlxText;
    public var black:FlxColor;
    public var white:FlxColor;
    public var outline:FlxColor;
    public var greenSelect:FlxColor;

    public function new() {
        super();

        greenSelect = GameGlobal.getColor('fill');
        outline = GameGlobal.getColor('outline');
        black = GameGlobal.getColor('black');
        white = GameGlobal.getColor('white');

        var nav = GameGlobal.getSelectionInputs("navigation");
        var back = GameGlobal.getSelectionInputs(null, Action.B);
        var conf = GameGlobal.getSelectionInputs(null, Action.A);

        FlxG.mouse.visible = false;
        panelRec = new FlxSprite(10, 10, Paths.image('ui/menu/window'));
        panelRec.setGraphicSize(460, 250);
        panelRec.updateHitbox();
        panelRec.alpha = 0.4;
        add(panelRec);

        selectionText = new FlxText(40, 50, 400, "Choose Your Character");
        selectionText.setFormat(Paths.font('upheaval-pro-regular'), 30, greenSelect, CENTER, OUTLINE, outline);
        add(selectionText);

        ddImage = new FlxSprite(110, 100, Paths.image('ui/menu/icon_dd'));
        ddImage.setGraphicSize(64, 64);
        ddImage.updateHitbox();
        add(ddImage);

        bfImage = new FlxSprite(288, 100, Paths.image('ui/menu/icon_bf'));
        bfImage.setGraphicSize(64, 64);
        bfImage.updateHitbox();
        add(bfImage);

        ddText = new FlxText(ddImage.x + 16, 165, 32, "DD");
        ddText.setFormat(Paths.font('upheaval-pro-regular'), 21, outline, CENTER, OUTLINE, outline);
        add(ddText);

        bfText = new FlxText(bfImage.x + 16, 165, 32, "BF");
        bfText.setFormat(Paths.font('upheaval-pro-regular'), 21, greenSelect, CENTER, OUTLINE, outline);
        add(bfText);

        directionText = new FlxText(20, 205, 440, 'Navigation: ${nav} - Select: ${conf}');
        directionText.setFormat(Paths.font('upheaval-pro-regular'), 17, white, CENTER, OUTLINE, black);
        directionText.screenCenter(X);
        add(directionText);

        directionText = new FlxText(35, 230, 440, 'Return - ${back}');
        directionText.setFormat(Paths.font('upheaval-pro-regular'), 15, white, CENTER, OUTLINE, black);
        directionText.screenCenter(X);
        add(directionText);

        considerSelection();
    };

    override function update(elapsed:Float) {
        super.update(elapsed);

        if(Controls.justPressed.LEFT || Controls.justPressed.RIGHT) considerSelection(true);
        if(Controls.justPressed.B) {
            FlxG.sound.play(Paths.sound('back'), Options.inGameSoundVolume());
            MenuState.moveOn = false;
            tankmasfunkin.states.GameOverState.moveOn = false;
            FlxG.mouse.visible = true;
            close();
        }
        if(Controls.justPressed.A) {
            PlayState.SONG = Song.loadFromJson('spiritoftankmas', 'level');
            PlayState.charInt = curSelect;
            Rating.resetRatingAmount();
            Global.switchState(new LoadingState(new PlayState(), true));
        }
    }

    function considerSelection(?change:Bool = false)
        {
            if (change) {
                FlxG.sound.play(Paths.sound('nav'), Options.inGameSoundVolume() * 1.5);
                if (curSelect == 1) {
                    curSelect = 0;
                    ddText.color = greenSelect;
                    bfText.color = outline;
                } else {
                    curSelect = 1;
                    bfText.color = greenSelect;
                    ddText.color = outline;
                }
            }
        }
}