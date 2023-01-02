package tankmasfunkin.states;

import tankmasfunkin.states.LoadingState;
import tankmasfunkin.states.MenuState;
import tankmasfunkin.states.PlayState;
import tankmasfunkin.game.Highscore;
import tankmasfunkin.game.Song;
import tankmasfunkin.global.Paths;
import tankmasfunkin.global.GameGlobal;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.FlxSubState;
import flixel.FlxG;

class CharSelectSubState extends FlxSubState {
    public var curSelect:Int = 1;
    public var panelRec:FlxSprite;
    public var selectionText:FlxText;
    public var ddImage:FlxSprite;
    public var bfImage:FlxSprite;
    public var ddText:FlxText;
    public var bfText:FlxText;
    public var directionText:FlxText;
    public var green:FlxColor;
    public var red:FlxColor;
    public var greenSelect:FlxColor;

    public function new() {
        super();

        var nav = GameGlobal.getSelectionInputs("navigation");
        var back = GameGlobal.getSelectionInputs("back");
        var conf = GameGlobal.getSelectionInputs("selection");

        green = FlxColor.GREEN;
        green.brightness = 0.3;

        red = FlxColor.RED;
        red.brightness = 0.6;

        greenSelect = FlxColor.GREEN;
        greenSelect.brightness = 1.4;

        FlxG.mouse.visible = false;
        panelRec = new FlxSprite(10, 10);
        panelRec.makeGraphic(460, 250, green);
        panelRec.alpha = 0.3;
        add(panelRec);

        panelRec = new FlxSprite(15, 15);
        panelRec.makeGraphic(450, 240, red);
        panelRec.alpha = 0.3;
        add(panelRec);

        panelRec = new FlxSprite(20, 20);
        panelRec.makeGraphic(440, 230, green);
        panelRec.alpha = 0.3;
        add(panelRec);

        selectionText = new FlxText(50, 50, 400, "Choose Your Character");
        selectionText.setFormat(null, 24, FlxColor.WHITE, CENTER);
        add(selectionText);

        ddImage = new FlxSprite(60, 100, Paths.image('ui/menu/icon_dd'));
        ddImage.setGraphicSize(64, 64);
        ddImage.updateHitbox();
        add(ddImage);

        bfImage = new FlxSprite(338, 100, Paths.image('ui/menu/icon_bf'));
        bfImage.setGraphicSize(64, 64);
        bfImage.updateHitbox();
        add(bfImage);

        ddText = new FlxText(ddImage.x + 16, 165, 32, "DD");
        ddText.setFormat(null, 16, FlxColor.WHITE, CENTER);
        add(ddText);

        bfText = new FlxText(bfImage.x + 16, 165, 32, "BF");
        bfText.setFormat(null, 16, greenSelect, CENTER);
        add(bfText);

        directionText = new FlxText(20, 205, 440, 'Use ${nav} and ${conf} to select!');
        directionText.setFormat(null, 12, FlxColor.WHITE, CENTER);
        add(directionText);

        directionText = new FlxText(35, 235, 440, 'Press ${back} to return to the previous screen.');
        directionText.setFormat(null, 10, FlxColor.WHITE, CENTER);
        add(directionText);

        considerSelection();
    };

    override function update(elapsed:Float) {
        super.update(elapsed);

        if(Controls.justPressed.LEFT || Controls.justPressed.RIGHT) considerSelection(true);
        if(Controls.justPressed.B) {
            MenuState.moveOn = false;
            MenuState.doorOpen.alpha = 0;
            MenuState.doorClosed.alpha = 1;
            tankmasfunkin.states.GameOverState.moveOn = false;
            FlxG.mouse.visible = true;
            close();
        }
        if(Controls.justPressed.A) {
            PlayState.SONG = Song.loadFromJson('spiritoftankmas', 'level');
            PlayState.charInt = curSelect;
            LoadingState.loadAndSwitchState(new PlayState(), true);
        }
    }

    function considerSelection(?change:Bool = false)
        {
            if (change) {
                if (curSelect == 1) {
                    curSelect = 0;
                    ddText.color = greenSelect;
                    bfText.color = FlxColor.WHITE;
                } else {
                    curSelect = 1;
                    bfText.color = greenSelect;
                    ddText.color = FlxColor.WHITE;
                }
            }
        }
}