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

        var back = GameGlobal.getSelectionInputs("back");
        var conf = GameGlobal.getSelectionInputs("selection");

        var green = FlxColor.GREEN;
        green.brightness = 0.3;

        var red = FlxColor.RED;
        red.brightness = 0.6;

        panelRec = new FlxSprite(10, 10);
        panelRec.makeGraphic(460, 250, green);
        add(panelRec);

        panelRec = new FlxSprite(15, 15);
        panelRec.makeGraphic(450, 240, red);
        add(panelRec);

        panelRec = new FlxSprite(20, 20);
        panelRec.makeGraphic(440, 230, green);
        add(panelRec);

        mainScreen = new Array<FlxSprite>();

        selectionText = new FlxText(50, 20, 400, "Credits");
        selectionText.setFormat(null, 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);
        

        creditsIcon = new FlxSprite(60, 55, Paths.image('ui/icon_spd'));
        creditsIcon.setGraphicSize(64, 64);
        creditsIcon.updateHitbox();
        mainScreen.push(creditsIcon);
        add(creditsIcon);

        creditsIcon = new FlxSprite(154, 55, Paths.image('ui/icon_jrx'));
        creditsIcon.setGraphicSize(64, 64);
        creditsIcon.updateHitbox();
        mainScreen.push(creditsIcon);
        add(creditsIcon);

        creditsIcon = new FlxSprite(248, 55, Paths.image('ui/icon_tds'));
        creditsIcon.setGraphicSize(64, 64);
        creditsIcon.updateHitbox();
        mainScreen.push(creditsIcon);
        add(creditsIcon);

        creditsIcon = new FlxSprite(342, 55, Paths.image('ui/icon_jdg'));
        creditsIcon.setGraphicSize(64, 64);
        creditsIcon.updateHitbox();
        mainScreen.push(creditsIcon);
        add(creditsIcon);

        selectionText = new FlxText(45, 120, 94, "SplatterDash");
        selectionText.setFormat(null, 11, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        button1 = new FlxSpriteButton(45, 55, null, () -> FlxG.openURL('https://splatterdash.newgrounds.com/'));
        button1.makeGraphic(Std.int(selectionText.width), Std.int(selectionText.height + 65), FlxColor.BLACK);
        button1.alpha = 0.5;
        mainScreen.push(button1);
        add(button1);

        selectionText = new FlxText(139, 120, 94, "JRetrioX");
        selectionText.setFormat(null, 11, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        button1 = new FlxSpriteButton(139, 55, null, () -> FlxG.openURL('https://jretriox.newgrounds.com/'));
        button1.makeGraphic(Std.int(selectionText.width), Std.int(selectionText.height + 65), FlxColor.BLUE);
        button1.alpha = 0.5;
        mainScreen.push(button1);
        add(button1);

        selectionText = new FlxText(233, 120, 94, "TheDyingSun");
        selectionText.setFormat(null, 11, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        button1 = new FlxSpriteButton(233, 55, null, () -> FlxG.openURL('https://thedyingsun.newgrounds.com/'));
        button1.makeGraphic(Std.int(selectionText.width), Std.int(selectionText.height + 65), FlxColor.PURPLE);
        button1.alpha = 0.5;
        mainScreen.push(button1);
        add(button1);

        selectionText = new FlxText(327, 120, 94, "JDogg");
        selectionText.setFormat(null, 11, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        button1 = new FlxSpriteButton(327, 55, null, () -> FlxG.openURL('https://jdogg539.newgrounds.com/'));
        button1.makeGraphic(Std.int(selectionText.width), Std.int(selectionText.height + 65), FlxColor.YELLOW);
        button1.alpha = 0.5;
        mainScreen.push(button1);
        add(button1);

        selectionText = new FlxText(55, 135, 80, 'Organizer, Musician, Coder');
        selectionText.setFormat(null, 7, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        selectionText = new FlxText(149, 135, 74, "Sprite/UI Artist");
        selectionText.setFormat(null, 8, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        selectionText = new FlxText(243, 135, 74, 'Background/\nSprite Artist');
        selectionText.setFormat(null, 8, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        selectionText = new FlxText(337, 135, 74, 'Chart Creator');
        selectionText.setFormat(null, 8, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        selectionText = new FlxText(20, 155, 210, 'Menu Music - "Christmas Medley" (lhavf)');
        selectionText.setFormat(null, 9, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        button1 = new FlxSpriteButton(20, 155, null, () -> FlxG.openURL('https://www.newgrounds.com/audio/listen/385499'));
        button1.makeGraphic(Std.int(selectionText.width), Std.int(selectionText.height), FlxColor.RED);
        button1.alpha = 0.5;
        mainScreen.push(button1);
        add(button1);

        selectionText = new FlxText(235, 155, 210, 'Game Over Music - "8Bit Chiptune Christmas Medley" (Fantomenk)');
        selectionText.setFormat(null, 9, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        mainScreen.push(selectionText);
        add(selectionText);

        button1 = new FlxSpriteButton(235, 155, null, () -> FlxG.openURL('https://www.newgrounds.com/audio/listen/293004'));
        button1.makeGraphic(Std.int(selectionText.width), Std.int(selectionText.height), FlxColor.GREEN);
        button1.alpha = 0.5;
        mainScreen.push(button1);
        add(button1);

        thanksScreen = new Array<FlxSprite>();

        selectionText = new FlxText(50, 20, 400, "- Special Thanks -");
        selectionText.setFormat(null, 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        thanksScreen.push(selectionText);
        add(selectionText);

        selectionText = new FlxText(20, 55, 440, '>Previous Calendar Organizers: TurkeyOnAStick (NG 2012), PuffballsUnited (Flash 2012), ninjamuffin (NG 2018), BrandyBuizel & GeoKureli (NG 2019, 2020 & 2022), TheDyingSun & KnoseDoge (NG 2021)\n> Advent Calendar Teams Past And Present (check out the Tankmas Adventure collection to see them all!)\n> The NG Community & Tom Fulp (our lord and savior)\n> The Funkin Crew - ${Controls.mode == Keys ? 'CLICK' : 'TAP'} HERE TO SUPPORT DA FUNK');
        selectionText.setFormat(null, 12, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        thanksScreen.push(selectionText);
        add(selectionText);

        button1 = new FlxSpriteButton(45, 155, null, () -> FlxG.openURL('https://www.newgrounds.com/audio/listen/293004'));
        button1.makeGraphic(Std.int(selectionText.width), Std.int(selectionText.height), FlxColor.PINK);
        thanksScreen.push(button1);
        add(button1);

        selectionText = new FlxText(35, 235, 440, 'Return to Main Menu: ${back} --- Next Page: ${conf}');
        selectionText.setFormat(null, 10, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        selectionText.x = 240 - (selectionText.width / 2);
        add(selectionText);

        for(item in thanksScreen) {
            item.kill();
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if(Controls.justPressed.A) {
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
            tankmasfunkin.states.MenuState.credits = false;
            close();
        }
    }
}