package tankmasfunkin.game;
import tankmasfunkin.states.PlayState;
using StringTools;

class Boyfriend extends Character
{

	public function new(x:Float, y:Float, ?char:String = 'bf', ?isPlayer = true)
	{
		super(x, y, char, isPlayer);
	}

	override function update(elapsed:Float)
	{
		if (!debugMode)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}
			else
				holdTimer = 0;

			if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && !debugMode)
			{
				playAnim('idle', true, false, 10);
			}

			else if(PlayState.charInt == 0 && animation.curAnim.name.startsWith('sing') && animation.curAnim.finished)
				{
					playAnim('idle', true);
				};
		}

		super.update(elapsed);
	}
}