package ui;

import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import tankmasfunkin.global.Options;

/**
 * Man, getting this to be modular was a pain LOL
 * 
 * This system is part of the Tankmas minigame
 * package, and all games comply with the controls
 * set in here. When the team and I made the
 * decision to go independent, we had the idea to
 * implement a control-changing feature, so I had
 * to tweak this to make it work.
 * 
 * Geo I'm so sorry if I broke this and didn't know
 * LOL
 */

class Controls extends flixel.FlxBasic
{
    static public var pressed     (default, null):ControlsList;
    static public var justPressed (default, null):ControlsList;
    static public var justReleased(default, null):ControlsList;
    static public var released    (default, null):ControlsList;
    
    static public var mode(default, null) = Keys;
    static public var useKeys (get, never):Bool; inline static function get_useKeys () return mode == Keys;
    static public var useTouch(get, never):Bool; inline static function get_useTouch() return mode == Touch;
    static public var usePad  (get, never):Bool; inline static function get_usePad  () return mode == Gamepad;
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        mode = switch (mode)
        {
            case Keys if (FlxG.keys.pressed.ANY): Keys;
            case Keys if (FlxG.gamepads.anyPressed(ANY)): Gamepad;
            case Gamepad if (FlxG.gamepads.anyPressed(ANY)): Gamepad;
            case Gamepad if (FlxG.keys.pressed.ANY): Gamepad; 
            case _: mode;
        }

        if(FlxG.keys.pressed.ESCAPE) Options.setUiOption('fullscreen', false);
    }
    
    static var instance:Controls = null;
    static public function init()
    {
        if (instance != null)
            FlxG.plugins.remove(instance);
        
        pressed      = new ControlsList(PRESSED);
        justPressed  = new ControlsList(JUST_PRESSED);
        justReleased = new ControlsList(JUST_RELEASED);
        released     = new ControlsList(RELEASED);
        
        instance = new Controls();
        instance.active = !FlxG.onMobile;
        FlxG.plugins.add(instance);
    }
}

class ControlsList
{
    public static var keys:Map<Action, Array<FlxKey>> =
        [ UP       => [W, UP   ]
        , DOWN     => [S, DOWN ]
        , LEFT     => [A, LEFT ]
        , RIGHT    => [D, RIGHT]
        , A        => [Z, SPACE]
        , B        => [X, ESCAPE]
        , PAUSE    => [P, ENTER]
        ];
    
    public static var buttons:Map<Action, Array<FlxGamepadInputID>> =
        [ UP       => [DPAD_UP   , LEFT_STICK_DIGITAL_UP   ]
        , DOWN     => [DPAD_DOWN , LEFT_STICK_DIGITAL_DOWN ]
        , LEFT     => [DPAD_LEFT , LEFT_STICK_DIGITAL_LEFT ]
        , RIGHT    => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT]
        , A        => [A, X]
        , B        => [B, Y]
        , PAUSE    => [START]
        ];
    
    var state:FlxInputState;
    
    public function new (state:FlxInputState)
    {
        this.state = state;
    }
    
    public function check(action:Action)
    {
        return Controls.useKeys ? checkKeys(action) : checkButtons(action);
    }
    
    function checkAny()
    {
        @:privateAccess
        return FlxG.keys.checkStatus(FlxKey.ANY, state) || FlxG.gamepads.anyHasState(FlxGamepadInputID.ANY, state);
    }
    
    function checkKeys(action:Action)
    {
        @:privateAccess
        return FlxG.keys.checkKeyArrayState(keys[action], state);
    }
    
    function checkButtons(action:Action)
    {
        for (buttonId in buttons[action])
        {
            @:privateAccess
            if (FlxG.gamepads.anyHasState(buttonId, state))
                return true;
        }
        return false;
    }

    public static function saveKeyBinds()
        {
            FlxG.save.data.keyBinds = keys;
            FlxG.save.data.buttonBinds = buttons;
            FlxG.save.flush();
        }

    public static function loadKeyBinds()
        {
            if (FlxG.save.data.keyBinds) keys = FlxG.save.data.keyBinds;
            if (FlxG.save.data.buttonBinds) buttons = FlxG.save.data.buttonBinds;
        }

        // public function bindKeys(action:Action, keyToAdd:FlxKey)
        //     {
        //         //forEachBound(control, function(action, state) addKeys(action, keys, state));
                

        //     }

        //     public function unbindKeys(action:Action, keyToRem:FlxKey)
        //     {
        //         //forEachBound(control, function(action, _) removeKeys(action, keys));
                
        //     }

        //     public function bindButtons(action:Action, buttonToAdd:FlxGamepadInputID)
        //         {
        //             //forEachBound(control, function(action, state) addKeys(action, keys, state));
                    
    
        //         }
    
        //         public function unbindButtons(action:Action, buttonToRem:FlxGamepadInputID)
        //         {
        //             //forEachBound(control, function(action, _) removeKeys(action, keys));
                    
        //         }
    
    public var UP      (get, never):Bool; inline function get_UP      () return check(Action.UP      );
    public var DOWN    (get, never):Bool; inline function get_DOWN    () return check(Action.DOWN    );
    public var LEFT    (get, never):Bool; inline function get_LEFT    () return check(Action.LEFT    );
    public var RIGHT   (get, never):Bool; inline function get_RIGHT   () return check(Action.RIGHT   );
    public var A       (get, never):Bool; inline function get_A       () return check(Action.A       );
    public var B       (get, never):Bool; inline function get_B       () return check(Action.B       );
    public var PAUSE   (get, never):Bool; inline function get_PAUSE   () return check(Action.PAUSE   );
    public var ANY     (get, never):Bool; inline function get_ANY     () return checkAny();
}

enum Action
{
    UP;
    DOWN;
    LEFT;
    RIGHT;
    A;
    B;
    PAUSE;
}

enum ControlMode
{
    Touch;
    Keys;
    Gamepad;
}