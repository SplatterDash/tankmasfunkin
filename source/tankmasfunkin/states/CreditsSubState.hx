package tankmasfunkin.states;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.ui.FlxSpriteButton;
import flixel.system.FlxSound;
import flixel.FlxSubState;
import flixel.FlxG;
import tankmasfunkin.global.Paths;
import tankmasfunkin.global.GameGlobal;
import tankmasfunkin.global.Options;

/**
 * This wasn't really that hard to do, it was
 * just tedious making sure everything was
 * aligned properly and that buttons were in
 * the right places.
 */

class CreditsSubState extends FlxSubState {
    public var panelRec:FlxSprite;
    public var selectionText:FlxText;
    public var creditsIcon:FlxSprite;
    public var mainScreen:Array<FlxSprite>;
    public var thanksScreen:Array<FlxSprite>;
    public var button1:FlxSpriteButton;
    public var link:String;
    public var moveOn:Bool;
    public static var page:Int = 0;

    public function new(moveOn:Bool = true) {
        super();

        var back = GameGlobal.getSelectionInputs(null, Action.B);
        var conf = GameGlobal.getSelectionInputs(null, Action.A);

        panelRec = new FlxSprite(10, 10, Paths.image('ui/menu/window'));
        panelRec.setGraphicSize(460, 250);
        panelRec.updateHitbox();
        add(panelRec);

        mainScreen = new Array<FlxSprite>();

        selectionText = new FlxText(50, 20, 400, "Credits");
        selectionText.setFormat(null, 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        selectionText = new FlxText(50, 45, 400, "Click on any credit to view the NG page!");
        selectionText.setFormat(null, 8, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);
        

        creditsIcon = new FlxSprite(60, 60, Paths.image('ui/menu/icon_spd'));
        creditsIcon.setGraphicSize(64, 64);
        creditsIcon.updateHitbox();
        mainScreen.push(creditsIcon);
        add(creditsIcon);

        creditsIcon = new FlxSprite(154, 60, Paths.image('ui/menu/icon_jrx'));
        creditsIcon.setGraphicSize(64, 64);
        creditsIcon.updateHitbox();
        mainScreen.push(creditsIcon);
        add(creditsIcon);

        creditsIcon = new FlxSprite(248, 60, Paths.image('ui/menu/icon_tds'));
        creditsIcon.setGraphicSize(64, 64);
        creditsIcon.updateHitbox();
        mainScreen.push(creditsIcon);
        add(creditsIcon);

        creditsIcon = new FlxSprite(342, 60, Paths.image('ui/menu/icon_jdg'));
        creditsIcon.setGraphicSize(64, 64);
        creditsIcon.updateHitbox();
        mainScreen.push(creditsIcon);
        add(creditsIcon);

        selectionText = new FlxText(45, 125, 94, "SplatterDash");
        selectionText.setFormat(null, 11, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        button1 = new FlxSpriteButton(45, 60, null, () -> FlxG.openURL('https://splatterdash.newgrounds.com/'));
        button1.makeGraphic(Std.int(selectionText.width), Std.int(selectionText.height + 65), FlxColor.BLACK);
        button1.alpha = 0;
        mainScreen.push(button1);
        add(button1);

        selectionText = new FlxText(139, 125, 94, "JRetrioX");
        selectionText.setFormat(null, 11, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        button1 = new FlxSpriteButton(139, 60, null, () -> FlxG.openURL('https://jretriox.newgrounds.com/'));
        button1.makeGraphic(Std.int(selectionText.width), Std.int(selectionText.height + 65), FlxColor.BLUE);
        button1.alpha = 0;
        mainScreen.push(button1);
        add(button1);

        selectionText = new FlxText(233, 125, 94, "TheDyingSun");
        selectionText.setFormat(null, 11, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        button1 = new FlxSpriteButton(233, 60, null, () -> FlxG.openURL('https://thedyingsun.newgrounds.com/'));
        button1.makeGraphic(Std.int(selectionText.width), Std.int(selectionText.height + 65), FlxColor.PURPLE);
        button1.alpha = 0;
        mainScreen.push(button1);
        add(button1);

        selectionText = new FlxText(327, 125, 94, "JDogg");
        selectionText.setFormat(null, 11, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        button1 = new FlxSpriteButton(327, 60, null, () -> FlxG.openURL('https://jdogg539.newgrounds.com/'));
        button1.makeGraphic(Std.int(selectionText.width), Std.int(selectionText.height + 65), FlxColor.YELLOW);
        button1.alpha = 0;
        mainScreen.push(button1);
        add(button1);

        selectionText = new FlxText(55, 137, 80, 'Organizer, Musician, Coder');
        selectionText.setFormat(null, 7, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        selectionText = new FlxText(149, 137, 74, "Sprite/UI Artist");
        selectionText.setFormat(null, 8, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        selectionText = new FlxText(243, 137, 74, 'Background/\nSprite Artist');
        selectionText.setFormat(null, 8, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        selectionText = new FlxText(337, 137, 74, 'Chart Creator');
        selectionText.setFormat(null, 8, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        selectionText = new FlxText(30, 166, 210, 'Menu Music - "Christmas Medley" (lhavf)');
        selectionText.setFormat(null, 9, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        button1 = new FlxSpriteButton(30, 166, null, () -> FlxG.openURL('https://www.newgrounds.com/audio/listen/385499'));
        button1.makeGraphic(Std.int(selectionText.width), Std.int(selectionText.height), FlxColor.RED);
        button1.alpha = 0;
        mainScreen.push(button1);
        add(button1);

        selectionText = new FlxText(245, 166, 210, 'Game Over Music - "8Bit Chiptune Christmas Medley" (Fantomenk)');
        selectionText.setFormat(null, 9, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        button1 = new FlxSpriteButton(245, 166, null, () -> FlxG.openURL('https://www.newgrounds.com/audio/listen/293004'));
        button1.makeGraphic(Std.int(selectionText.width), Std.int(selectionText.height), FlxColor.GREEN);
        button1.alpha = 0;
        mainScreen.push(button1);
        add(button1);

        selectionText = new FlxText(30, 200, 0, 'Song - "Spirit of Tankmas" (SplatterDash)');
        selectionText.setFormat(null, 11, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        selectionText.screenCenter(X);
        mainScreen.push(selectionText);
        add(selectionText);

        button1 = new FlxSpriteButton(30, 200, null, () -> FlxG.openURL('https://www.newgrounds.com/audio/listen/1189795'));
        button1.makeGraphic(Std.int(selectionText.width), Std.int(selectionText.height), FlxColor.GREEN);
        button1.screenCenter(X);
        button1.alpha = 0;
        mainScreen.push(button1);
        add(button1);

        thanksScreen = new Array<FlxSprite>();

        selectionText = new FlxText(50, 20, 400, "- Special Thanks -");
        selectionText.setFormat(null, 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        thanksScreen.push(selectionText);
        add(selectionText);

        selectionText = new FlxText(20, 55, 430, '>Previous Calendar Organizers: TurkeyOnAStick (NG 2012), PuffballsUnited (Flash 2012), ninjamuffin (NG 2018), BrandyBuizel & GeoKureli (NG 2019, 2020 & 2022), TheDyingSun & KnoseDoge (NG 2021)\n> Advent Calendar Teams Past And Present (check out the Tankmas Adventure collection to see them all!)\n> The NG Community & Tom Fulp (our lord and savior)\n> The Funkin Crew');
        selectionText.setFormat(null, 12, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        selectionText.screenCenter(X);
        thanksScreen.push(selectionText);
        add(selectionText);

        selectionText = new FlxText(0, 180, 0, '${Controls.mode == Keys ? 'CLICK' : 'TAP'} HERE TO SUPPORT DA FUNK');
        selectionText.setFormat(null, 21, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        thanksScreen.push(selectionText);
        add(selectionText);
        selectionText.screenCenter(X);

        button1 = new FlxSpriteButton(selectionText.x, 180, null, () -> FlxG.openURL('https://www.newgrounds.com/portal/view/770371'));
        button1.makeGraphic(Std.int(selectionText.width), Std.int(selectionText.height), FlxColor.PINK);
        button1.alpha = 0;
        thanksScreen.push(button1);
        add(button1);

        selectionText = new FlxText(0, 205, 0, "(right where it originated!)");
        selectionText.setFormat(null, 12, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        thanksScreen.push(selectionText);
        add(selectionText);
        selectionText.screenCenter(X);

        selectionText = new FlxText(35, 225, 440, 'Return to Main Menu: ${back} --- Next Page: ${conf}');
        selectionText.setFormat(null, 10, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        selectionText.screenCenter(X);
        add(selectionText);

        for(item in thanksScreen) {
            item.kill();
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if(Controls.justPressed.A) {
            FlxG.sound.play(Paths.sound('nav'), Options.inGameSoundVolume() * 1.5);
            if(page == 0) {
                for(item in mainScreen) {
                    item.kill();
                }

                for(item in thanksScreen) {
                    item.revive();
                }
                page++;
            } else {
                for(item in thanksScreen) {
                    item.kill();
                }

                for(item in mainScreen) {
                    item.revive();
                }
                page--;
            }
        }

        if(Controls.justPressed.B) {
            FlxG.sound.play(Paths.sound('back'), Options.inGameSoundVolume());
            tankmasfunkin.states.MenuState.credits = false;
            close();
        }
    }
}