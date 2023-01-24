package tankmasfunkin.states;

import tankmasfunkin.global.GameGlobal;
import tankmasfunkin.global.NGio;
import tankmasfunkin.global.APIData;

import ui.Controls;

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