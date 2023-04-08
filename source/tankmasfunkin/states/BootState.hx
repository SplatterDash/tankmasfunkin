package tankmasfunkin.states;

import tankmasfunkin.global.GameGlobal;
import tankmasfunkin.global.NGio;
import tankmasfunkin.global.APIData;
import flixel.FlxG;
import tankmasfunkin.global.Options;

import ui.Controls;

/**
 * This was added because these were always being
 * initiated when the game hit the menu, instead
 * of just being called once at startup and then
 * not needing to be called again.
 */

class BootState extends flixel.FlxState {

    override public function create (){
        super.create();
        Controls.init();
        GameGlobal.initialized = false;
        GameGlobal.init();

        FlxG.game.soundTray.scaleX = 1;
        FlxG.game.soundTray.scaleY = 1;
        FlxG.game.soundTray.x += 50;
        FlxG.mouse.cursorContainer.scaleX = 0.5;
        FlxG.mouse.cursorContainer.scaleY = 0.5;

        if(!FlxG.save.data.keyBinds) ControlsList.saveKeyBinds() else ControlsList.loadKeyBinds();
        if(!FlxG.save.data.uiOptions) Options.saveUiOptions() else Options.loadUiOptions();
        if(!FlxG.save.data.volumeSettings) Options.saveVolumeValues() else Options.loadVolumeValues();
        Options.checkForAllOptions();  // Had to place this in as without it the game fails to load thanks to a late Fullscreen option
        if(Options.getUiOption('fullscreen')) { 
            Options.setUiOption('fullscreen', false);
        }
        var NGio = new NGio(APIData.apiKey, APIData.encrypKey);
        Global.switchState(new MenuState());
    }
}