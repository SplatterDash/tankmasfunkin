package tankmasfunkin.states;

import flixel.FlxBasic;
import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUISpriteButton;
import tankmasfunkin.global.Paths;
import tankmasfunkin.global.GameGlobal;
import tankmasfunkin.global.Options;
import tankmasfunkin.global.InputFormatter;
import tankmasfunkin.global.NGio;
import tankmasfunkin.global.APIData;
import tankmasfunkin.game.Rating;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxSlider;

/**I literally kid you not, I coded the majority
 * of this ham-fisted, compacted Options menu in
 * a couple of days. This included tasks such as
 * modifying the Tankmas `Controls.hx` file to
 * incorporate a control changer, cheating by
 * looking at Psych Engine's code, creating the
 * `Options.hx` file, and much more.
 */

class OptionsSubState extends flixel.FlxSubState {
    public var optionOptions:Array<String> = ['How To Play', 'Controls Config', 'Audio Config'];
    public var inVolume:Bool = false;
    public var inControls:Bool = false;
    public var inPlay:Bool = false;
    public var remap:Bool = false;
    public var volAdj:Bool = false;
    public var mainOptionChoice:Int = 1;
    public var controlChoice:Int = 0;
    public var volumeChoice:Int = 1;
    public var playPage:Int = 1;

    public var fillColor:FlxColor;
    public var outlineColor:FlxColor;

    public var mainBG:FlxSprite;
    public var cursor:FlxSprite;
    public var mainOptionsAssets:Array<Dynamic>;
    public var volumeAssets:Array<Dynamic>;
    public var controlAssets:Array<Dynamic>;
    public var playAssets:Map<Int, Array<Dynamic>>;
    public var playPageArray:Array<Dynamic>;

    public static var masterSound:FlxSprite;
    public var masterSoundBar:FlxSlider;
    public var masterSoundY:Int;
    public static var sfxSound:FlxSprite;
    public var sfxSoundBar:FlxSlider;
    public var sfxSoundY:Int;
    public static var musicSound:FlxSprite;
    public var musicSoundBar:FlxSlider;
    public var musicSoundY:Int;
    public var secretButton:FlxUISpriteButton;

    public var controlOptions:Array<Dynamic> = [
        ['Left', Action.LEFT],
        ['Up', Action.UP],
        ['Down', Action.DOWN],
        ['Right', Action.RIGHT],
        ['Select', Action.A],
        ['Back', Action.B],
        ['Pause', Action.PAUSE]
    ];
    public var defaultKey:FlxKey;
    public var subKey:FlxKey;
    public var controlChoices:Array<FlxText>;
    public var curAlt:Bool = false;
    public var remapArray:Array<FlxSprite>;
    public var remapBG:FlxSprite;
    public var remapText:FlxText;
    public var buttonExpanded:Bool = false;

    public var controlAnim:FlxSprite;


    //yes I did hamfist an entire options menu into one script without going into separate subscripts, what about it
    public function new() {
        super();
        FlxG.mouse.enabled = false;
        FlxG.mouse.visible = false;
        masterSound = new FlxSprite(Options.volumeMap.get("masterVolume") * 100, 0);
        sfxSound = new FlxSprite(Options.volumeMap.get("sfxVolume") * 100, 0);
        musicSound = new FlxSprite(Options.volumeMap.get("musicVolume") * 100, 0);

        fillColor = GameGlobal.getColor('fill');
		outlineColor = GameGlobal.getColor('outline');

        mainBG = new FlxSprite(10, 10, Paths.image('ui/menu/window'));
        mainBG.setGraphicSize(460, 250);
        mainBG.updateHitbox();
        add(mainBG);

        // creating assets for main options menu
        mainOptionsAssets = new Array<Dynamic>();
        var selectionText = new FlxText(50, 30, 400, "Options");
        selectionText.setFormat(Paths.font('upheaval-pro-regular'), 40, fillColor, CENTER, OUTLINE, outlineColor);
        selectionText.screenCenter(X);
        mainOptionsAssets.push(selectionText);
        add(selectionText);

        for(i in 0...optionOptions.length) {
            selectionText = new FlxText(50, 90 + (40 * i), 300, optionOptions[i]);
            selectionText.setFormat(Paths.font('upheaval-pro-regular'), 30, fillColor, CENTER, OUTLINE, outlineColor);
            selectionText.ID = i;
            selectionText.screenCenter(X);
            mainOptionsAssets.push(selectionText);
            add(selectionText);
        }

        cursor = new FlxSprite(60, mainOptionsAssets[1].y + (mainOptionsAssets[1].height / 2) - 15 , Paths.image('ui/menu/pointer'));
		add(cursor);

        // creating assets for volume menu
        volumeAssets = new Array<Dynamic>();
        var selectionText = new FlxText(50, 40, 400, 'Audio Config');
        selectionText.setFormat(Paths.font('upheaval-pro-regular'), 36, fillColor, CENTER, OUTLINE, outlineColor);
        selectionText.screenCenter(X);
        volumeAssets.push(selectionText);
        add(selectionText);

        masterSoundBar = new FlxSlider(masterSound, "x", 140, 60, 0, 100, 200, 25, 15, fillColor, outlineColor);
        masterSoundBar.nameLabel.text = 'Master Volume';
        masterSoundBar.nameLabel.setFormat(Paths.font('upheaval-pro-regular'), 17, fillColor, CENTER, OUTLINE, outlineColor);
        masterSoundBar.hoverAlpha = 1;
        masterSoundBar.valueLabel.setFormat(Paths.font('upheaval-pro-regular'), 17, fillColor, CENTER, OUTLINE, outlineColor);
        masterSoundBar.maxLabel.setFormat(Paths.font('upheaval-pro-regular'), 15, fillColor, CENTER, OUTLINE, outlineColor);
        masterSoundBar.minLabel.setFormat(Paths.font('upheaval-pro-regular'), 15, fillColor, CENTER, OUTLINE, outlineColor);
        volumeAssets.push(masterSoundBar);
        add(masterSoundBar);

        sfxSoundBar = new FlxSlider(sfxSound, "x", 140, 120, 0, 100, 200, 25, 15, fillColor, outlineColor);
        sfxSoundBar.nameLabel.text = 'SFX Volume';
        sfxSoundBar.nameLabel.setFormat(Paths.font('upheaval-pro-regular'), 17, fillColor, CENTER, OUTLINE, outlineColor);
        sfxSoundBar.hoverAlpha = 1;
        sfxSoundBar.valueLabel.setFormat(Paths.font('upheaval-pro-regular'), 17, fillColor, CENTER, OUTLINE, outlineColor);
        sfxSoundBar.maxLabel.setFormat(Paths.font('upheaval-pro-regular'), 15, fillColor, CENTER, OUTLINE, outlineColor);
        sfxSoundBar.minLabel.setFormat(Paths.font('upheaval-pro-regular'), 15, fillColor, CENTER, OUTLINE, outlineColor);
        volumeAssets.push(sfxSoundBar);
        add(sfxSoundBar);

        musicSoundBar = new FlxSlider(musicSound, "x", 140, 180, 0, 100, 200, 25, 15, fillColor, outlineColor);
        musicSoundBar.nameLabel.text = 'Music Volume';
        musicSoundBar.nameLabel.setFormat(Paths.font('upheaval-pro-regular'), 17, fillColor, CENTER, OUTLINE, outlineColor);
        musicSoundBar.hoverAlpha = 1;
        musicSoundBar.valueLabel.setFormat(Paths.font('upheaval-pro-regular'), 17, fillColor, CENTER, OUTLINE, outlineColor);
        musicSoundBar.maxLabel.setFormat(Paths.font('upheaval-pro-regular'), 15, fillColor, CENTER, OUTLINE, outlineColor);
        musicSoundBar.minLabel.setFormat(Paths.font('upheaval-pro-regular'), 15, fillColor, CENTER, OUTLINE, outlineColor);
        volumeAssets.push(musicSoundBar);
        add(musicSoundBar);


        // creating assets for control menu
        controlAssets = new Array<Dynamic>();
        var selectionText = new FlxText(50, 35, 400, 'Controls Config');
        selectionText.setFormat(Paths.font('upheaval-pro-regular'), 36, fillColor, CENTER, OUTLINE, outlineColor);
        selectionText.screenCenter(X);
        controlAssets.push(selectionText);
        add(selectionText);

        controlChoices = new Array<FlxText>();

        for(i in 0...controlOptions.length) {
            var keyList = ControlsList.keys.get(controlOptions[i][1]);
            defaultKey = InputFormatter.getKeyName(keyList[0]);
            subKey = InputFormatter.getKeyName(keyList[1]);

            selectionText = new FlxText(30, 65 + (25 * i), 240, controlOptions[i][0]);
            selectionText.setFormat(Paths.font('upheaval-pro-regular'), 30, fillColor, CENTER, OUTLINE, outlineColor);
            controlAssets.push(selectionText);
            add(selectionText);

            selectionText = new FlxText(125, 65 + (25 * i), 240, defaultKey.toString());
            selectionText.setFormat(Paths.font('upheaval-pro-regular'), 30, outlineColor, CENTER, OUTLINE, outlineColor);
            controlChoices.push(selectionText);
            controlAssets.push(selectionText);
            add(selectionText);

            selectionText = new FlxText(190, 65 + (25 * i), 240, subKey.toString());
            selectionText.setFormat(Paths.font('upheaval-pro-regular'), 30, outlineColor, CENTER, OUTLINE, outlineColor);
            controlChoices.push(selectionText);
            controlAssets.push(selectionText);
            add(selectionText);
        }

        remapArray = new Array<FlxSprite>();
        remapBG = new FlxSprite(0, 0);
        remapBG.makeGraphic(Global.width, Global.height, FlxColor.BLACK);
        remapBG.alpha = 0.1;
        remapArray.push(remapBG);
        add(remapBG);

        remapText = new FlxText(0, 180, Global.width, "Press any key to rebind!");
        remapText.setFormat(Paths.font('upheaval-pro-regular'), 24, FlxColor.WHITE, CENTER, OUTLINE, outlineColor);
        remapText.screenCenter(X);
        remapArray.push(remapText);
        add(remapText);

        remapText = new FlxText(0, 0, Global.width, "REMAPPING ERROR");
        remapText.setFormat(Paths.font('upheaval-pro-regular'), 38, fillColor, CENTER, OUTLINE, outlineColor);
        remapText.screenCenter();
        remapArray.push(remapText);
        add(remapText);

        secretButton = new FlxUISpriteButton(0, 0, null, () -> {
            NGio.unlockMedal(APIData.hiddenMedal);
            var watchout = FlxG.sound.load(Paths.sound('youbetterwatchout'));
            watchout.onComplete = function() {
                secretButton.setGraphicSize(1, 1);
                secretButton.updateHitbox();
            };
            watchout.volume = Options.inGameSoundVolume();
            if(!buttonExpanded) {
                secretButton.setGraphicSize(150, 150);
                secretButton.updateHitbox();
                watchout.play(true, 0);
            } else {
                secretButton.setGraphicSize(1, 1);
                secretButton.updateHitbox();
                if(watchout.playing) watchout.pause();
            }
        });
        secretButton.loadGraphic(Paths.image('gonebutnotforgor/tomloveschristmasthenightmaresarebackohgODHELPUSALL'));
        secretButton.setGraphicSize(1, 1);
        secretButton.updateHitbox();
        controlAssets.push(secretButton);
        add(secretButton);

        // creating assets for how to play screens
        playAssets = new Map<Int, Array<Dynamic>>();
        var selectionText = new FlxText(50, 20, 400, "How To Play");
        selectionText.setFormat(Paths.font('upheaval-pro-regular'), 40, fillColor, CENTER, OUTLINE, outlineColor);
        selectionText.screenCenter(X);
        playAssets.set(0, [selectionText]);
        add(selectionText);

        var itemValue:Int = 0;

        for(i in 0...4) {
            playPageArray = new Array<Dynamic>();

            switch(i) {
                case 0:
                    var selectionText = new FlxText(50, 47, 400, "Da Goal");
                    selectionText.setFormat(Paths.font('upheaval-pro-regular'), 25, fillColor, CENTER, OUTLINE, outlineColor);
                    selectionText.screenCenter(X);
                    playPageArray.push(selectionText);
                    add(selectionText);

                    selectionText = new FlxText(50, 100, 400, "Inspired by the coolest funkin game on NG, this special celebration of the annual tradition known as the non-denominational Tankmas is, like the event it's based off of, all for fun. Choose between DD or BF and enjoy an eight-minute mashup of songs from past and present! (Just don't go AFK, I'll be watching you)");
                    selectionText.setFormat(Paths.font('upheaval-pro-regular'), 19, fillColor, CENTER, OUTLINE, outlineColor);
                    selectionText.screenCenter();
                    selectionText.y += 10;
                    playPageArray.push(selectionText);
                    add(selectionText);
                case 1:
                    var selectionText = new FlxText(50, 47, 400, "About Health");
                    selectionText.setFormat(Paths.font('upheaval-pro-regular'), 25, fillColor, CENTER, OUTLINE, outlineColor);
                    selectionText.screenCenter(X);
                    playPageArray.push(selectionText);
                    add(selectionText);

                    selectionText = new FlxText(50, 100, 400, "Unlike other FNF creations out there, Tankmas Funkin has no health system. That means no matter which character you play as, you can still try your best to go for the highest score! While missed notes and ghost tapping will not deduct your health, they will still deduct from your score, and missed notes reset your combo, so do your best!");
                    selectionText.setFormat(Paths.font('upheaval-pro-regular'), 19, fillColor, CENTER, OUTLINE, outlineColor);
                    selectionText.screenCenter();
                    selectionText.y += 10;
                    playPageArray.push(selectionText);
                    add(selectionText);
                    
                case 2:
                    var selectionText = new FlxText(50, 47, 400, "Using the Controls");
                    selectionText.setFormat(Paths.font('upheaval-pro-regular'), 25, fillColor, CENTER, OUTLINE, outlineColor);
                    selectionText.screenCenter(X);
                    playPageArray.push(selectionText);
                    add(selectionText);

                    selectionText = new FlxText(188, 162, 0, '${ControlsList.keys.get(Action.LEFT)[0]}\n${ControlsList.keys.get(Action.LEFT)[1]}');
                    selectionText.setFormat(Paths.font('upheaval-pro-regular'), 10, fillColor, CENTER, OUTLINE, outlineColor);
                    selectionText.x -= (selectionText.width / 2);
                    playPageArray.push(selectionText);
                    add(selectionText);

                    selectionText = new FlxText(224, 162, 0, '${ControlsList.keys.get(Action.UP)[0]}\n${ControlsList.keys.get(Action.UP)[1]}');
                    selectionText.setFormat(Paths.font('upheaval-pro-regular'), 10, fillColor, CENTER, OUTLINE, outlineColor);
                    selectionText.x -= (selectionText.width / 2);
                    playPageArray.push(selectionText);
                    add(selectionText);

                    selectionText = new FlxText(260, 162, 0, '${ControlsList.keys.get(Action.DOWN)[0]}\n${ControlsList.keys.get(Action.DOWN)[1]}');
                    selectionText.setFormat(Paths.font('upheaval-pro-regular'), 10, fillColor, CENTER, OUTLINE, outlineColor);
                    selectionText.x -= (selectionText.width / 2);
                    playPageArray.push(selectionText);
                    add(selectionText);

                    selectionText = new FlxText(296, 162, 0, '${ControlsList.keys.get(Action.RIGHT)[0]}\n${ControlsList.keys.get(Action.RIGHT)[1]}');
                    selectionText.setFormat(Paths.font('upheaval-pro-regular'), 10, fillColor, CENTER, OUTLINE, outlineColor);
                    selectionText.x -= (selectionText.width / 2);
                    playPageArray.push(selectionText);
                    add(selectionText);

                    controlAnim = new FlxSprite(50, 120);
                    controlAnim.frames = Paths.getSparrowAtlas('ui/menu/tutorialAnim');
                    controlAnim.animation.addByPrefix('run', 'Lemme Show You How To Rap It', 2, true);
                    controlAnim.antialiasing = false;
                    controlAnim.setGraphicSize(Std.int(controlAnim.width * 0.9));
                    controlAnim.screenCenter();
                    controlAnim.y += 5;
                    playPageArray.push(controlAnim);
                    add(controlAnim);
                    controlAnim.animation.play('run', true);
                case 3:
                    var selectionText = new FlxText(50, 47, 400, "Score Values");
                    selectionText.setFormat(Paths.font('upheaval-pro-regular'), 25, fillColor, CENTER, OUTLINE, outlineColor);
                    selectionText.screenCenter(X);
                    playPageArray.push(selectionText);
                    add(selectionText);

                    for(key in Options.scoreMap.keys()) {
                        var infoGraphic = new FlxSprite(200 + (80 * (Options.scoreMap[key][1] % 2)), 90 + (60 * Math.floor(Options.scoreMap[key][1] / 2)), Paths.image('ui/${key}'));
                        infoGraphic.x -= infoGraphic.width / 2;
                        playPageArray.push(infoGraphic);
                        add(infoGraphic);

                        selectionText = new FlxText(0, infoGraphic.y + infoGraphic.height, 0, '${Options.scoreMap[key][0]} pts');
                        selectionText.setFormat(Paths.font('upheaval-pro-regular'), 12, fillColor, CENTER, OUTLINE, outlineColor);
                        selectionText.x = infoGraphic.x + (infoGraphic.width / 2) - (selectionText.width / 2);
                        playPageArray.push(selectionText);
                        add(selectionText);
                    }
                    
                    selectionText = new FlxText(50, 220, 400, "-10 point deduction per missed note/ghost tap!");
                    selectionText.setFormat(Paths.font('upheaval-pro-regular'), 12, fillColor, CENTER, OUTLINE, outlineColor);
                    selectionText.screenCenter(X);
                    selectionText.y -= selectionText.height;
                    playPageArray.push(selectionText);
                    add(selectionText);
                case 4:
                    var selectionText = new FlxText(50, 47, 400, "Ratings");
                    selectionText.setFormat(Paths.font('upheaval-pro-regular'), 25, fillColor, CENTER, OUTLINE, outlineColor);
                    selectionText.screenCenter(X);
                    playPageArray.push(selectionText);
                    add(selectionText);

                    selectionText = new FlxText(50, 66, 400, "yeeee boi we got em");
                    selectionText.setFormat(Paths.font('upheaval-pro-regular'), 7, fillColor, CENTER, OUTLINE, outlineColor);
                    selectionText.screenCenter(X);
                    playPageArray.push(selectionText);
                    add(selectionText);

                    for(key in Rating.ratingMap.keys()) 
                    {
                        if(Rating.ratingMap[key] != 'penis.') {
                            selectionText = new FlxText(0, 97 + (17 * itemValue), '${Rating.ratingMap[key]} - ${key} total pts.');
                            selectionText.setFormat(Paths.font('upheaval-pro-regular'), 12, fillColor, CENTER, OUTLINE, outlineColor);
                            selectionText.screenCenter(X);
                            playPageArray.push(selectionText);
                            add(selectionText);
                            itemValue++;
                    }
                }
            }
            playAssets.set(i + 1, playPageArray);
        }

        selectionText = new FlxText(0, 0, 440, 'Return to Options: ${GameGlobal.getSelectionInputs(null, Action.B)} - Next Page: ${GameGlobal.getSelectionInputs(null, Action.A) + ' or ' + GameGlobal.getSelectionInputs(null, Action.RIGHT)} - Prev Page: ${GameGlobal.getSelectionInputs(null, Action.LEFT)}');
        selectionText.setFormat(Paths.font('upheaval-pro-regular'), 12, FlxColor.WHITE, CENTER, OUTLINE, outlineColor);
        selectionText.screenCenter(X);
        selectionText.y = 245 - selectionText.height;
        playAssets.set(5, [selectionText]);
        add(selectionText);

        //and now, the final preparations
        for (asset in volumeAssets) asset.kill();
        for (asset in controlAssets) asset.kill();
        for (asset in remapArray) asset.visible = false;
        for (value in playAssets) {
            for (asset in value) asset.kill();
        }

        for(i in 0...controlChoices.length){
            controlChoices[i].ID = i;
        }

    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        // control text selection indicator
        for (txt in controlChoices)
            {
                if(txt.ID == controlChoice) {
                    txt.setFormat(Paths.font('upheaval-pro-regular'), 25, fillColor, CENTER, OUTLINE, outlineColor);
                } else {
                    txt.setFormat(Paths.font('upheaval-pro-regular'), 25, outlineColor, CENTER, OUTLINE, outlineColor);
                }
            }

        if(Controls.justPressed.ANY && !remap) {

            //per control options, all go from volume to controls to how-to-play and then finally main options
            if (Controls.justPressed.B) {
                FlxG.sound.play(Paths.sound('back'), Options.inGameSoundVolume());
                if (!inVolume && !inControls && !inPlay) {
                    tankmasfunkin.states.MenuState.options = false;
                    FlxG.mouse.enabled = true;
                    FlxG.mouse.visible = true;
                    close();
                } else {
                    if (inVolume) { 
                        for(asset in volumeAssets) asset.kill();
                        inVolume = false;
                        cursor.x = 60;
                        cursor.y = mainOptionsAssets[mainOptionChoice].y + (mainOptionsAssets[mainOptionChoice].height / 2) - 15;
                    } else if (inControls) {
                        for(asset in controlAssets) asset.kill();
                        inControls = false;
                        cursor.alpha = 1;
                        FlxG.mouse.enabled = false;
                    } else {
                        for (value in playAssets) {
                            for (asset in value) asset.kill();
                        }
                        inPlay = false;
                        cursor.alpha = 1;
                    }
                    for(asset in mainOptionsAssets) asset.alpha = 1;
                }
            }
            if (Controls.justPressed.DOWN) {
                FlxG.sound.play(Paths.sound('nav'), Options.inGameSoundVolume());
                if (inVolume && !volAdj) {
                    if(volumeChoice == 3) volumeChoice = 1;
                    else volumeChoice++;
                }
                else if (inControls) {
                    if(controlChoice == controlChoices.length - 1) controlChoice = 0 else controlChoice++;
                }
                else if (!inPlay) {
                    if(mainOptionChoice == 3) mainOptionChoice = 1;
                    else mainOptionChoice++;
                }
            }
            if (Controls.justPressed.UP) {
                FlxG.sound.play(Paths.sound('nav'), Options.inGameSoundVolume());
                if (inVolume && !volAdj) {
                    if(volumeChoice == 1) volumeChoice = 3;
                    else volumeChoice--;
                }
                else if (inControls) {
                    if(controlChoice == 0) controlChoice = controlChoices.length - 1 else controlChoice--;
                }
                else if (!inPlay) {
                    if(mainOptionChoice == 1) mainOptionChoice = 3
                    else mainOptionChoice--;
                }
                  
            }
            if(Controls.justPressed.LEFT) {
                if (inVolume && volAdj) {
                    switch (volumeChoice) {
                        case 1:
                            if (masterSound.x <= 1) masterSound.x = 0 else masterSound.x -= 2;
                            masterSoundBar.value = masterSound.x;
                        case 2:
                            if (sfxSound.x <= 1) sfxSound.x = 0 else sfxSound.x -= 2;
                            sfxSoundBar.value = sfxSound.x;
                        case 3:
                            if (musicSound.x <= 1) musicSound.x = 0 else musicSound.x -= 2;
                            musicSoundBar.value = musicSound.x;
                    }
                } else if (inPlay) {
                    for(asset in playAssets[playPage]) asset.kill();
                    if (playPage == 1) playPage = 5 else playPage--;
                    for(asset in playAssets[playPage]) asset.revive();
                }
            }
            if(Controls.justPressed.RIGHT) {
                if (inVolume && volAdj) {
                    switch(volumeChoice) {
                        case 1:
                            if (masterSound.x >= 99) masterSound.x = 100 else masterSound.x += 2;
                            masterSoundBar.value = masterSound.x;
                        case 2:
                            if (sfxSound.x >= 99) sfxSound.x = 100 else sfxSound.x += 2;
                            sfxSoundBar.value = sfxSound.x;
                        case 3:
                            if (musicSound.x >= 99) musicSound.x = 100 else musicSound.x += 2;
                            musicSoundBar.value = musicSound.x;
                    }
                } else if (inPlay) {
                    for(asset in playAssets[playPage]) asset.kill();
                    if (playPage == 5) playPage = 1 else playPage++;
                    for(asset in playAssets[playPage]) asset.revive();
                }
            };
            if(inVolume || volAdj) {
                cursor.x = 50;
                cursor.y = volumeAssets[volumeChoice].y + (volumeAssets[volumeChoice].height / 2) + 15;
            } else {
                cursor.x = 60;
                cursor.y = mainOptionsAssets[mainOptionChoice].y + (mainOptionsAssets[mainOptionChoice].height / 2) - 15;
            }
            if(Controls.justPressed.A) {
                if(inVolume){
                    if(volAdj) {
                        switch(volumeChoice) {
                            case 1: 
                                Options.volumeMap.set("masterVolume", Std.parseFloat(Std.string(masterSound.x / 100)));
                                trace(Options.volumeMap);
                                FlxG.sound.music.volume = Options.inGameMusicVolume();
                            case 2:
                                Options.volumeMap.set("sfxVolume", Std.parseFloat(Std.string(sfxSound.x / 100)));
                                trace(Options.volumeMap);
                                FlxG.sound.play(Paths.sound('confirm'), Options.inGameSoundVolume());
                            case 3:
                                Options.volumeMap.set("musicVolume", musicSound.x / 100);
                                trace(Options.volumeMap);
                                FlxG.sound.music.volume = Options.inGameMusicVolume();
                        }
                    }
                    volAdj = !volAdj;
                } else if(inControls){
                    if (!remap) switch(controlChoice) {
                        case 1, 3, 5, 7, 9, 11, 13:
                            curAlt = true;
                        default: curAlt = false;
                    }
                    for (asset in remapArray) asset.visible = true;
                    remapText.text = 'Remapping ${controlOptions[Math.floor(controlChoice / 2)][0]} ${curAlt ? 'Alt' : "Main"}...';
                    remapText.screenCenter();
                    remap = !remap;
                } else if (inPlay){
                    for(asset in playAssets[playPage]) asset.kill();
                    if (playPage == 5) playPage = 1 else playPage++;
                    for(asset in playAssets[playPage]) asset.revive();

                } else {
                    for(asset in mainOptionsAssets) asset.alpha = 0;
                    switch (optionOptions[mainOptionChoice - 1]) {
                    case "Audio Config":
                        for(asset in volumeAssets) asset.revive();
                        inVolume = true;
                        cursor.x = 50;
                        cursor.y = volumeAssets[volumeChoice].y + (volumeAssets[volumeChoice].height / 2) + 15;
                    case "Controls Config":
                        for(asset in controlAssets) asset.revive();
                        cursor.alpha = 0;
                        inControls = true;
                        FlxG.mouse.enabled = true;
                    case "How To Play":
                        for (asset in playAssets[0]) asset.revive();
                        for (asset in playAssets[5]) asset.revive();
                        for (asset in playAssets[playPage]) asset.revive();
                        cursor.alpha = 0;
                        inPlay = true;
                    }
                }
                FlxG.sound.play(Paths.sound('confirm1'), Options.inGameSoundVolume());
            }
        }
            else if(remap) {
                
                //button remapping, modification of Psych Engine code
                if (remapBG.alpha < 0.6) remapBG.alpha += 0.05;
                if(FlxG.keys.firstJustPressed() > -1) {
                        var keysArray:Array<FlxKey> = ControlsList.keys.get(controlOptions[Math.floor(controlChoice / 2)][1]);
                        keysArray[curAlt ? 1 : 0] = FlxG.keys.firstJustPressed();
        
                        var opposite:Int = (curAlt ? 0 : 1);
                        if(keysArray[opposite] == keysArray[1 - opposite]) {
                            keysArray[opposite] = NONE;
                        }
                        ControlsList.keys.set(controlOptions[Math.floor(controlChoice / 2)][1], keysArray);
        
                        Controls.init();
                        FlxG.sound.play(Paths.sound('confirm1'), Options.inGameSoundVolume());

                        for(i in 0...controlChoices.length) {
                            var keyList = ControlsList.keys.get(controlOptions[Math.floor(i / 2)][1]);
                            var key = InputFormatter.getKeyName(keyList[i % 2]);
                            controlChoices[i].text = key.toString();
                        }
                    for (asset in remapArray) asset.visible = false;
                    remapBG.alpha = 0.1;
                    remap = !remap;
                    curAlt = false;
                }
            }
    }
}