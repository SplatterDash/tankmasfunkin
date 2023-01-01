package tankmasfunkin.states;

import flixel.group.FlxSpriteGroup;
import tankmasfunkin.game.Section.SwagSection;
import tankmasfunkin.game.Song;
import tankmasfunkin.game.Song.SwagSong;
import tankmasfunkin.game.Note;
import tankmasfunkin.game.Character;
import tankmasfunkin.game.Boyfriend;
import tankmasfunkin.game.Conductor;
import tankmasfunkin.game.Highscore;
import tankmasfunkin.states.MusicBeatState;
import tankmasfunkin.states.GameOverState;
import tankmasfunkin.global.Paths;
import tankmasfunkin.global.GameGlobal;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

using StringTools;

/** 
 * Worth noting that this entire project got coded in a week,
 * quite a bit came from FNF's source but a lot also had to be
 * tweaked to fit this minigame. Still, go give the FNF source
 * a shoutout!
**/
class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;


	//ladies and gantlemen and non-binary friends, the wall-o-assets
	public static var bg:FlxSprite;
	public static var sky:FlxSprite;
	public static var lights:FlxSprite;
	public static var mountains:FlxSprite;
	public static var candle:FlxSprite;
	public static var shader:FlxSprite;
	public static var bg2018:FlxSprite;
	public static var bg2019:FlxSprite;
	public static var bg2020:FlxSprite;
	public static var bg2021:FlxSprite;
	public static var white:FlxSprite;
	public static var tom:FlxSprite;

	public var alphaAdd = 0.005;
	public var stopFollow:Bool = false;
	public static var inZoomProgress:Bool = false;

	private var vocals:FlxSound;

	private var dad:Character;
	private var boyfriend:Boyfriend;
	public static var charInt:Int = 0;
	public static var curChar:Character;
	public static var oppChar:Character;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var combo:Int = 0;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	private var hudOverlay:FlxTypedGroup<FlxBasic>;

	var Boppers1:FlxSprite;
	var Boppers2:FlxSprite;
	var Boppers3:FlxSprite;

	public static var songScore:Int = 0;
	var scoreTxt:FlxText;

	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 2.6;

	//This is the Start function
	override function create()
	{
		camGame = new FlxCamera();
		//camHUD = new FlxCamera();
		//camHUD.bgColor.alpha = 0;

		Global.camera.set_camera(camGame);

		persistentUpdate = true;
		persistentDraw = true;

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

	    curStage = 'holiday';
		defaultCamZoom = 0.80;

		sky = new FlxSprite(-69, -105).loadGraphic(Paths.image('stage/sky'));
		sky.antialiasing = true;
		sky.scrollFactor.set(0.4, 1);
		sky.active = false;
		sky.setGraphicSize(Std.int(sky.width * 1.2));
		sky.updateHitbox();
		add(sky);

		mountains = new FlxSprite(-159, -105).loadGraphic(Paths.image('stage/mountains'));
		mountains.antialiasing = true;
		mountains.scrollFactor.set(0.7, 1);
		mountains.active = false;
		mountains.setGraphicSize(Std.int(mountains.width * 1.2));
		mountains.updateHitbox();
		add(mountains);

		tom = new FlxSprite(0, 70).loadGraphic(Paths.image('ui/tomourlordandsavior'));
		tom.antialiasing = true;
		tom.scrollFactor.set(1, 1);
		tom.active = false;
		tom.setGraphicSize(Std.int(tom.width * 1.5));
		tom.updateHitbox();
		tom.x = mountains.getMidpoint().x - (tom.width / 2);
		tom.alpha = 0;
		add(tom);

		bg = new FlxSprite(-159, -105).loadGraphic(Paths.image('stage/wall'));
		bg.antialiasing = true;
		bg.scrollFactor.set(1, 1);
		bg.active = false;
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		add(bg);

		bg2018 = new FlxSprite(-250, -50).loadGraphic(Paths.image('stage/tankmas2018_fullshot'));
		bg2018.antialiasing = true;
		bg2018.scrollFactor.set();
		bg2018.active = false;
		bg2018.alpha = 0;
		bg2018.setGraphicSize(Std.int(bg2018.width * 1.8));
		bg2018.updateHitbox();
		add(bg2018);

		bg2019 = new FlxSprite(-50, -225).loadGraphic(Paths.image('stage/tankmas2019_fullshot'));
		bg2019.antialiasing = true;
		bg2019.scrollFactor.set();
		bg2019.active = false;
		bg2019.alpha = 0;
		bg2019.setGraphicSize(Std.int(bg2019.width * 2.3));
		bg2019.updateHitbox();
		add(bg2019);

		bg2020 = new FlxSprite(-350, -50).loadGraphic(Paths.image('stage/tankmas2020_fullshot'));
		bg2020.antialiasing = true;
		bg2020.scrollFactor.set();
		bg2020.active = false;
		bg2020.alpha = 0;
		bg2020.setGraphicSize(Std.int(bg2020.width * 1.5));
		bg2020.updateHitbox();
		add(bg2020);

		bg2021 = new FlxSprite(0, -100).loadGraphic(Paths.image('stage/tankmas2021_fullshot'));
		bg2021.antialiasing = true;
		bg2021.scrollFactor.set();
		bg2021.active = false;
		bg2021.alpha = 0;
		bg2021.setGraphicSize(Std.int(bg2021.width * 1));
		bg2021.updateHitbox();
		add(bg2021);

		candle = new FlxSprite(100, 125);
		candle.frames = Paths.getSparrowAtlas('stage/candle');
		candle.animation.addByPrefix('flicker', 'candle flicker', 10, true);
		candle.antialiasing = false;
		candle.alpha = 0;
		candle.setGraphicSize(Std.int(candle.width * daPixelZoom));
		candle.updateHitbox();
		add(candle);

		//upperBoppers = new FlxSprite(-240, -90);
		// upperBoppers.frames = Paths.getSparrowAtlas('stage/upperBop');
		// upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
		// upperBoppers.antialiasing = true;
		// upperBoppers.scrollFactor.set(0.33, 0.33);
		// upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
		// upperBoppers.updateHitbox();
		// add(upperBoppers);

		// var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
		// tree.antialiasing = true;
		// tree.scrollFactor.set(0.40, 0.40);
		// add(tree);

		// bottomBoppers = new FlxSprite(-300, 140);
		// bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
		// bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
		// bottomBoppers.antialiasing = true;
		// 	bottomBoppers.scrollFactor.set(0.9, 0.9);
		// 	bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
		// bottomBoppers.updateHitbox();
		// add(bottomBoppers);

		// var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
		// fgSnow.active = false;
		// fgSnow.antialiasing = true;
		// add(fgSnow);
		          
			// default:
			// {
			// 		defaultCamZoom = 0.9;
			// 		curStage = 'stage';
			// 		var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
			// 		bg.antialiasing = true;
			// 		bg.scrollFactor.set(0.9, 0.9);
			// 		bg.active = false;
			// 		add(bg);

			// 		var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
			// 		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			// 		stageFront.updateHitbox();
			// 		stageFront.antialiasing = true;
			// 		stageFront.scrollFactor.set(0.9, 0.9);
			// 		stageFront.active = false;
			// 		add(stageFront);

			// 		var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
			// 		stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			// 		stageCurtains.updateHitbox();
			// 		stageCurtains.antialiasing = true;
			// 		stageCurtains.scrollFactor.set(1.3, 1.3);
			// 		stageCurtains.active = false;

			// 		add(stageCurtains);
			// }
		
		dad = new Character(-180, 0, SONG.player2, if (charInt == 0) true else false);

		var camPos:FlxPoint = new FlxPoint(bg.getGraphicMidpoint().x + 50, 85);

		//camPos.x += 200;
		//camPos.y -= 50;

		boyfriend = new Boyfriend(180, 0, SONG.player1, if (charInt == 1) true else false);
		trace(boyfriend.width);

		if(charInt == 0)
			{
				curChar = dad;
				oppChar = boyfriend;
			} else {
				curChar = boyfriend;
				oppChar = dad;
			}
		add(dad);
		add(boyfriend);

		lights = new FlxSprite(-169, -105).loadGraphic(Paths.image('stage/lights'));
		lights.antialiasing = true;
		lights.scrollFactor.set(1.1, 1);
		lights.active = false;
		lights.setGraphicSize(Std.int(lights.width * 1.2));
		lights.updateHitbox();
		add(lights);

		shader = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/shader'));
		shader.antialiasing = false;
		shader.alpha = 0;
		shader.setGraphicSize(Std.int(shader.width * (daPixelZoom + 0.7)));
		shader.updateHitbox();
		shader.x = candle.x + (candle.width / 2) - (shader.width / 2);
		shader.y = candle.y + (candle.height / 2) - (shader.height / 2);
		add(shader);

		white = new FlxSprite(-150, -150).loadGraphic(Paths.image('stage/white'));
		white.antialiasing = true;
		white.scrollFactor.set();
		white.active = false;
		white.alpha = 0;
		white.setGraphicSize(Std.int(white.width * 350));
		white.updateHitbox();
		add(white);

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 0).makeGraphic(Global.width, 10);
		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

		generateSong('spiritoftankmas');

		camFollow = new FlxObject(0, -500, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		Global.camera.follow(camFollow, LOCKON, 0.04);
		Global.camera.zoom = defaultCamZoom;
		Global.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, Global.width, Global.height);

		FlxG.fixedTimestep = false;

		scoreTxt = new FlxText((Global.width) / 2, 280, 0, "", 20);
		scoreTxt.setFormat(null, 16, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		add(scoreTxt);

		hudOverlay = new FlxTypedGroup<FlxBasic>();
		hudOverlay.camera = Global.camera;
		camHUD = hudOverlay.camera;

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];

		startingSong = true;
		startCountdown();

		super.create();
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{

		generateStaticArrows(0, if(charInt == 0) true else false);
		generateStaticArrows(1, if(charInt == 1) true else false);

		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();
					ready.setGraphicSize(Std.int(ready.width * daPixelZoom));
					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();
					set.setGraphicSize(Std.int(set.width * daPixelZoom));
					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();
					go.setGraphicSize(Std.int(go.width * daPixelZoom));
					go.updateHitbox();
					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
				case 4:
			}

			swagCounter += 1;
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		candle.animation.play('flicker', true);
	};

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
		{
			// FlxG.log.add(ChartParser.parse());
	
			var songData = SONG;
			Conductor.changeBPM(songData.bpm);
	
			curSong = songData.song;
	
			if (SONG.needsVoices)
				vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
			else
				vocals = new FlxSound();
	
			FlxG.sound.list.add(vocals);
	
			notes = new FlxTypedGroup<Note>();
			add(notes);
	
			var noteData:Array<SwagSection>;
	
			// NEW SHIT
			noteData = songData.notes;
	
			var playerCounter:Int = 0;
	
			var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
			for (section in noteData)
			{
				var coolSection:Int = Std.int(section.lengthInSteps / 4);
	
				for (songNotes in section.sectionNotes)
				{
					var daStrumTime:Float = songNotes[0];
					var daNoteData:Int = Std.int(songNotes[1] % 4);
	
					var gottaHitNote:Bool = section.mustHitSection;
					if (charInt == 0) {
						if (songNotes[1] < 4) gottaHitNote = !section.mustHitSection;
					}
					else {
						if (songNotes[1] > 3)
					{
						gottaHitNote = !section.mustHitSection;
					}}
	
					var oldNote:Note;
					if (unspawnNotes.length > 0)
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					else
						oldNote = null;
	
					var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, gottaHitNote);
					swagNote.sustainLength = songNotes[2];
					swagNote.scrollFactor.set(0, 0);
	
					var susLength:Float = swagNote.sustainLength;
	
					susLength = susLength / Conductor.stepCrochet;
					unspawnNotes.push(swagNote);
	
					for (susNote in 0...Math.floor(susLength))
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
	
						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, gottaHitNote, true);
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);
	
						sustainNote.mustPress = gottaHitNote;
	
						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset
						}
					}
	
					swagNote.mustPress = gottaHitNote;
	
					if (swagNote.mustPress)
					{
						swagNote.x += FlxG.width / 2; // general offset
					}
					else {}
				}
				daBeats += 1;
			}
	
			// trace(unspawnNotes.length);
			// playerCounter += 1;
	
			unspawnNotes.sort(sortByShit);
	
			generatedMusic = true;
		}
	

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int, ?isPlayerStrum = false):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
				
			babyArrow.loadGraphic(Paths.image('ui/tankmas_noteassets'), true, 19, 19);
			babyArrow.animation.add('green', [6]);
			babyArrow.animation.add('red', [7]);
			babyArrow.animation.add('blue', [5]);
			babyArrow.animation.add('purple', [4]);

			babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
			babyArrow.updateHitbox();
			babyArrow.antialiasing = false;

			switch (Math.abs(i))
			{
				case 0:
					babyArrow.x += Note.swagWidth * 0;
					babyArrow.animation.add('static', [0]);
					babyArrow.animation.add('pressed', [4, 8], 12, false);
					babyArrow.animation.add('confirm', [12, 16], 24, false);
				case 1:
					babyArrow.x += Note.swagWidth * 1;
					babyArrow.animation.add('static', [1]);
					babyArrow.animation.add('pressed', [5, 9], 12, false);
					babyArrow.animation.add('confirm', [13, 17], 24, false);
				case 2:
					babyArrow.x += Note.swagWidth * 2;
					babyArrow.animation.add('static', [2]);
					babyArrow.animation.add('pressed', [6, 10], 12, false);
					babyArrow.animation.add('confirm', [14, 18], 12, false);
				case 3:
					babyArrow.x += Note.swagWidth * 3;
					babyArrow.animation.add('static', [3]);
					babyArrow.animation.add('pressed', [7, 11], 12, false);
					babyArrow.animation.add('confirm', [15, 19], 24, false);
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.ID = i;

			if (isPlayerStrum)
			{
				playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 33;
			babyArrow.x += ((Global.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	/** This is where your game updates each frame */
	override function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		super.update(elapsed);

		scoreTxt.text = "Score:" + songScore;
		scoreTxt.x = (Global.width / 2) - (scoreTxt.width / 2);

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;

				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
				}
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && !stopFollow)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 175 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 175, dad.getMidpoint().y - 40);
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 165)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 165, boyfriend.getMidpoint().y - 45);
			}
		}

		if (camZooming)
		{
			trace('ZOOM' + defaultCamZoom);
			Global.camera.zoom = FlxMath.lerp(defaultCamZoom, Global.camera.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);
		var hudCamAlterZoom:Float = defaultCamZoom;
			switch (curBeat)
			{
				case 580:
					sky.alpha -= 0.2;
					mountains.alpha -= 0.2;
					bg.alpha -= 0.2;
					lights.alpha -= 0.2;
					candle.alpha += 0.2;
					shader.alpha += 0.2;
				case 612, 613, 614, 615, 616, 617, 618, 619:
					shader.alpha -= alphaAdd;
					if(bg2018.alpha == 0.5) {bg2018.alpha += 0;} else bg2018.alpha += alphaAdd;
					bg2018.x += 0.5;

				case 620, 621, 622, 623, 624, 625, 626, 627:
					bg2018.x += 0.5;
					bg2018.alpha -= alphaAdd;
					if(bg2019.alpha == 0.5) {bg2019.alpha += 0;} else bg2019.alpha += alphaAdd;
					bg2019.x -= 0.5;

				case 628, 629, 630, 631, 632, 633, 634, 635:
					bg2019.x -= 0.5;
					bg2019.alpha -= alphaAdd;
					if(bg2020.alpha == 0.5) {bg2020.alpha += 0;} else bg2020.alpha += alphaAdd;
					bg2020.x += 0.5;
					bg2018.kill();

				case 636, 637, 638, 639, 640, 641, 642:
					bg2020.x += 0.5;
					bg2020.alpha -= alphaAdd;
					if(bg2021.alpha == 0.5) {bg2021.alpha += 0;} else bg2021.alpha += alphaAdd;
					bg2021.x -= 0.5;
					bg2019.kill();

				case 643:
					bg2021.x -= 0.5;
					white.alpha += 0.05;
				case 644, 645, 646, 647:
					candle.kill();
					bg2020.kill();
					bg2021.kill();
					sky.alpha = 1;
					mountains.alpha = 1;
					bg.alpha = 1;
					lights.alpha = 1;
					white.alpha -= 0.01;
				case 676:
					stopFollow = true;
					camFollow.setPosition(125, 70);
				case 708, 709, 710, 711, 712, 713, 714, 715, 716, 717, 718, 719, 720, 721, 722, 723, 724, 725, 726, 727, 728, 729, 730, 731, 732, 733, 734, 735:
					//defaultCamZoom -= 0.0005;
					//hudCamAlterZoom += 0.0005;
					camZooming = false;
					inZoomProgress = true;
					tom.alpha = 1;
					//camHUD.setPosition(camHUD.x, camHUD.y + curCamY);
				case 740, 741, 742, 743, 744, 745, 746, 747:
					var overallFade:Float = 0.02;
					sky.alpha -= overallFade;
					mountains.alpha -= overallFade;
					bg.alpha -= overallFade;
					lights.alpha -= overallFade;
					boyfriend.alpha -= overallFade;
					dad.alpha -= overallFade;
				case 748, 749, 750:
					camHUD.alpha -= 0.05;
				case 751:
					tom.alpha -= 0.05;
			};

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > Global.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

				// i am so fucking sorry for this if condition
				if (daNote.isSustainNote
					&& daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
					swagRect.y /= daNote.scale.y;
					swagRect.height -= swagRect.y;

					daNote.clipRect = swagRect;
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (!inZoomProgress) camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					switch (Math.abs(daNote.noteData))
					{
						case 0:
							oppChar.playAnim('singLEFT' + altAnim, true);
						case 1:
							oppChar.playAnim('singDOWN' + altAnim, true);
						case 2:
							oppChar.playAnim('singUP' + altAnim, true);
						case 3:
							oppChar.playAnim('singRIGHT' + altAnim, true);
					}

					oppChar.holdTimer = 0;
					vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				if (daNote.y < -daNote.height)
				{
					if (daNote.tooLate || !daNote.wasGoodHit)
					{
						vocals.volume = 0;
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}
			keyShit();
	}

	function endSong():Void
	{
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(0, songScore);
			#end
		}
			trace('SONG COMPLETE');
			FlxG.sound.music.stop();
			Global.switchState(new GameOverState());
	}
	var endingSong:Bool = false;

	private function popUpScore(strumtime:Float):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(100, 0, 0, placement, 32);

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sweet";

		if (noteDiff > Conductor.safeZoneOffset * 0.9)
		{
			daRating = 'grinchy';
			score = 50;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			daRating = 'naughty';
			score = 100;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.2)
		{
			daRating = 'nice';
			score = 200;
		}

		songScore += score;
		scoreTxt.x = (Global.width / 2) - (scoreTxt.width / 2);




		rating.loadGraphic(Paths.image('ui/${daRating}'));
		rating.screenCenter();
		rating.x = coolText.x;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/combo'));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
		comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/num' + Std.int(i)));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 43;
			numScore.y += 10;
			numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}

		coolText.text = Std.string(seperatedScore);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	private function keyShit():Void
	{
		// HOLDING
		var up = Controls.pressed.UP;
		var right = Controls.pressed.RIGHT;
		var down = Controls.pressed.DOWN;
		var left = Controls.pressed.LEFT;

		var upP = Controls.justPressed.UP;
		var rightP = Controls.justPressed.RIGHT;
		var downP = Controls.justPressed.DOWN;
		var leftP = Controls.justPressed.LEFT;

		var upR = Controls.justReleased.UP;
		var rightR = Controls.justReleased.RIGHT;
		var downR = Controls.justReleased.DOWN;
		var leftR = Controls.justReleased.LEFT;

		var bugTestControl = Controls.justReleased.PAUSE;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		if(bugTestControl) endSong();

		if ((upP || rightP || downP || leftP) && !curChar.stunned && generatedMusic)
		{
			curChar.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);
				}
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (perfectMode)
					noteCheck(true, daNote);

				// Jump notes
				if (possibleNotes.length >= 2)
				{
					if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
					{
						for (coolNote in possibleNotes)
						{
							if (controlArray[coolNote.noteData])
								goodNoteHit(coolNote);
							else
							{
								var inIgnoreList:Bool = false;
								for (shit in 0...ignoreList.length)
								{
									if (controlArray[ignoreList[shit]])
										inIgnoreList = true;
								}
								if (!inIgnoreList)
									badNoteCheck();
							}
						}
					}
					else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
					{
						noteCheck(controlArray[daNote.noteData], daNote);
					}
					else
					{
						for (coolNote in possibleNotes)
						{
							noteCheck(controlArray[coolNote.noteData], coolNote);
						}
					}
				}
				else // regular notes?
				{
					noteCheck(controlArray[daNote.noteData], daNote);
				}
			}
			else
			{
				badNoteCheck();
			}
		}

		if ((up || right || down || left) && !curChar.stunned && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 0:
							if (left)
								goodNoteHit(daNote);
						case 1:
							if (down)
								goodNoteHit(daNote);
						case 2:
							if (up)
								goodNoteHit(daNote);
						case 3:
							if (right)
								goodNoteHit(daNote);
					}
				}
			});
		}

		if (curChar.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (curChar.animation.curAnim.name.startsWith('sing') && !curChar.animation.curAnim.name.endsWith('miss'))
			{
				if(charInt == 1) curChar.playAnim('idle') else curChar.dance();
			}
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			switch (spr.ID)
			{
				case 0:
					if (leftP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (leftR)
						spr.animation.play('static');
				case 1:
					if (downP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (downR)
						spr.animation.play('static');
				case 2:
					if (upP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (upR)
						spr.animation.play('static');
				case 3:
					if (rightP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (rightR)
						spr.animation.play('static');
			}

				spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (!curChar.stunned)
		{
			if (combo > 5)
			{
				//c-c-c-c-combo breaker!
			}
			combo = 0;

			songScore -= 10;
			scoreTxt.x = (Global.width / 2) - (scoreTxt.width / 2);

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

			curChar.stunned = true;

			// get stunned for 5 seconds
			new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
			{
				curChar.stunned = false;
			});

			switch (direction)
			{
				case 0:
					curChar.playAnim('singLEFTmiss', true);
				case 1:
					curChar.playAnim('singDOWNmiss', true);
				case 2:
					curChar.playAnim('singUPmiss', true);
				case 3:
					curChar.playAnim('singRIGHTmiss', true);
			}
		}
	}

	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		// I'm SplatterDash and I approve the message on line 1141
		var upP = Controls.justPressed.UP;
		var rightP = Controls.justPressed.RIGHT;
		var downP = Controls.justPressed.DOWN;
		var leftP = Controls.justPressed.LEFT;

		if (leftP)
			noteMiss(0);
		if (downP)
			noteMiss(1);
		if (upP)
			noteMiss(2);
		if (rightP)
			noteMiss(3);
	}

	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP)
			goodNoteHit(note);
		else
		{
			badNoteCheck();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime);
				combo += 1;
			}

			switch (note.noteData)
			{
				case 0:
					curChar.playAnim('singLEFT', true);
				case 1:
					curChar.playAnim('singDOWN', true);
				case 2:
					curChar.playAnim('singUP', true);
				case 3:
					curChar.playAnim('singRIGHT', true);
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				if(charInt == 0) oppChar.playAnim('idle', true) else oppChar.dance();
		}

		if (camZooming && Global.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			Global.camera.zoom += 0.015;
		}

		if (!curChar.animation.curAnim.name.startsWith("sing"))
		{
			if(charInt == 1) curChar.playAnim('idle') else curChar.dance();
		}
		//upperBoppers.animation.play('bop', true);
		//bottomBoppers.animation.play('bop', true);
	}
}