package tankmasfunkin.states;

import tankmasfunkin.global.GameGlobal;
import tankmasfunkin.global.NGio;
import tankmasfunkin.global.APIData;

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


        var NGio = new NGio(APIData.apiKey, APIData.encrypKey);
        Global.switchState(new MenuState());
    }
}