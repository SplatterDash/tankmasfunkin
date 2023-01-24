package tankmasfunkin.game;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import tankmasfunkin.global.Paths;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;
	public var stunned:Bool = false;
	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = false;

        var tex;

		switch (curCharacter)
		{
			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 12, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 12, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 12, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 12, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 12, false);
				animation.addByPrefix('singUPmiss', 'Dad Sing Note MISS UP', 12, false);
				animation.addByPrefix('singRIGHTmiss', 'Dad Sing Note MISS RIGHT', 12, false);
				animation.addByPrefix('singDOWNmiss', 'Dad Sing Note MISS DOWN', 12, false);
				animation.addByPrefix('singLEFTmiss', 'Dad Sing Note MISS LEFT', 12, false);

				playAnim('idle');

			case 'gf':
				tex = Paths.getSparrowAtlas('characters/GF');
				frames = tex;
				animation.addByIndices('danceLeft', 'GF Get Tankmas Jiggy With It', [0, 1, 2, 3, 3, 2, 1, 0], '', 12, false);
				animation.addByIndices('danceRight', 'GF Get Tankmas Jiggy With It', [0, 4, 5, 6, 6, 5, 4, 0], '', 12, false);
			case 'bf':
				tex = Paths.getSparrowAtlas('characters/BOYFRIEND');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 12, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 12, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 12, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 12, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 12, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 12, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 12, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 12, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 12, false);

				playAnim('idle');

				//flipX = true;
				
		}

		dance();

			// Doesn't flip for BF, since his are already in the right place???
			 if (!curCharacter.startsWith('bf') && !curCharacter.startsWith('gf'))
			 {
			 	// var animArray
			 	var oldRight = animation.getByName('singRIGHT').frames;
			 	animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
			 	animation.getByName('singLEFT').frames = oldRight;

			 	// IF THEY HAVE MISS ANIMATIONS??
			 	if (animation.getByName('singRIGHTmiss') != null)
			 	{
			 		var oldMiss = animation.getByName('singRIGHTmiss').frames;
			 		animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
			 		animation.getByName('singLEFTmiss').frames = oldMiss;
			 	}
			 }
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	public function dance()
	{
		if (!debugMode)	{
			switch (curCharacter) {
				case 'gf':
					danced = !danced;
					if(danced) playAnim('danceRight') else playAnim ('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);
		}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}