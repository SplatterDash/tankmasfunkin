package tankmasfunkin.states;

import tankmasfunkin.game.Section.SwagSection;
import tankmasfunkin.game.Song.SwagSong;
import tankmasfunkin.game.Note;
import tankmasfunkin.game.Character;
import tankmasfunkin.game.Boyfriend;
import tankmasfunkin.game.Conductor;
import tankmasfunkin.game.Rating;
import tankmasfunkin.states.MusicBeatState;
import tankmasfunkin.states.GameOverState;
import tankmasfunkin.global.Paths;
import tankmasfunkin.global.Options;
import tankmasfunkin.global.GameGlobal;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import flixel.ui.FlxBar;
import flixel.util.FlxStringUtil;

using StringTools;

/** 
 * I forgot about the blurb that was here and I
 * didn't update it before the initial release LOL
 * 
 * Long story short, to settle the debate: a good
 * majority of the code for the game came from FNF's
 * source, and that "most of the code" is here.
 * Only the things that were needed were carried
 * from the source, so things like FreeplayState,
 * Alphabet, and Dialogue were all left behind. The
 * things that made the gameplay work, such as Song,
 * Section and Note, were carried over because this
 * file called them. So technically I consider this a
 * mod because the core gameplay elements are here.
 * 
 * That's not to say everything in here's copy-pasted.
 * I had to change quite a bit, and because the source
 * called its stages from inside this file I used that
 * to create the stage. I had to also modify where the
 * strum line showed up because of the character
 * selection feature. Other additional things include
 * the events on each of the beats (stage disappearing,
 * characters appearing, things floating in the BG,
 * etc), combo breaks, and separation of vocals.
 * 
 * In Tankmas Funkin, the game seperates the vocals of
 * DD and BF. It stores them both in an array so that
 * when both need to do something at the same time, a
 * `for (vox in vocals)` loop could be called. As the 
 * player misses notes however, it could call upon only
 * the player's vocals and mute them instead of muting
 * the vocals on both sides.
 * 
 * I was also debating doing a time bar, but jEEZ when
 * I looked at Psych Engine's code to figure it out it
 * looked complicated as heck LOL. There's probably a
 * simpler way to do it, but I'm not gonna bother for
 * right now.
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
	public static var garland:FlxSprite;
	var Boppers1:FlxSprite;
	var Boppers2:FlxSprite;
	var Boppers3:FlxSprite;
	var Boppers4:FlxSprite;
	var fireplace:FlxSprite;

	public var alphaAdd = 0.005;
	public var stopFollow:Bool = false;
	public static var inZoomProgress:Bool = false;

	public static var vocals:Array<FlxSound>;
	private var curVocals:FlxSound;
	private var oppVocals:FlxSound;

	private var daBoppers:Array<FlxSprite>;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;
	public static var charInt:Int = 0;
	public static var curChar:Character;
	public static var oppChar:Character;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];
	public var scoreBar:FlxBar;
	public var timeText:FlxText;

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var lineX:Float = 153;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var combo:Int = 0;
	private var negativeCombo:Int = 0;
	private var negativeAmount:Int = 0;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;
	private var afk:Bool = false;

	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	private var hudOverlay:FlxTypedGroup<FlxBasic>;

	public static var bopSpeed:Float = 1;
	public static var garlandFrame:Int = 0;

	public static var songScore:Int = 0;
	public static var comboBreak:Int = 0;
	var scoreTxt:FlxText;
	var autoText:FlxText;
	var ratingTxt:String = "you didn't start dingus";

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 2.6;

	//Start function moment
	override function create()
	{

		camGame = new FlxCamera();
		songScore = 0;
		comboBreak = 0;
		combo = 0;
		negativeCombo = 0;
		negativeAmount = 0;

		Global.camera.set_camera(camGame);

		persistentUpdate = true;
		persistentDraw = true;

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

	    curStage = 'holiday'; //do we really need this?? probably not, at least not here, but screw it
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

		tom = new FlxSprite(0, 20).loadGraphic(Paths.image('ui/tomourlordandsavior'));
		tom.antialiasing = false;
		tom.scrollFactor.set(1, 1);
		tom.active = false;
		tom.updateHitbox();
		tom.x = mountains.getMidpoint().x - (tom.width / 2);
		tom.alpha = 0;
		add(tom);

		daBoppers = new Array<FlxSprite>();

		Boppers3 = new FlxSprite(-81, -40);
		Boppers3.frames = Paths.getSparrowAtlas('stage/bgchar');
		Boppers3.animation.addByPrefix('bop', "Bg Characters Bop", 12, false);
		Boppers3.antialiasing = false;
		Boppers3.scrollFactor.set(0.95, 1);
		Boppers3.setGraphicSize(Std.int(Boppers3.width * 1.2));
		Boppers3.updateHitbox();
		Boppers3.alpha = 0;
		add(Boppers3);
		daBoppers.push(Boppers3);

		Boppers2 = new FlxSprite(-80, 35);
		Boppers2.frames = Paths.getSparrowAtlas('stage/fgcharleft');
		Boppers2.animation.addByPrefix('bop', "Left Characters Bop", 12, false);
		Boppers2.antialiasing = false;
		Boppers2.scrollFactor.set(0.95, 1);
		Boppers2.setGraphicSize(Std.int(Boppers2.width * 1.2));
		Boppers2.updateHitbox();
		Boppers2.alpha = 0;
		add(Boppers2);
		daBoppers.push(Boppers2);

		Boppers1 = new FlxSprite(148, -40);
		Boppers1.frames = Paths.getSparrowAtlas('stage/fgcharright');
		Boppers1.animation.addByPrefix('bop', "Right Characters Bop", 12, false);
		Boppers1.antialiasing = false;
		Boppers1.scrollFactor.set(0.95, 1);
		Boppers1.setGraphicSize(Std.int(Boppers1.width * 1.2));
		Boppers1.updateHitbox();
		Boppers1.alpha = 0;
		add(Boppers1);
		daBoppers.push(Boppers1);

		bg = new FlxSprite(-179, -105).loadGraphic(Paths.image('stage/wall'));
		bg.antialiasing = false;
		bg.scrollFactor.set(1, 1);
		bg.active = false;
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		add(bg);

		bg2018 = new FlxSprite(-275, -90).loadGraphic(Paths.image('stage/tankmas2018_fullshot'));
		bg2018.antialiasing = true;
		bg2018.scrollFactor.set();
		bg2018.active = false;
		bg2018.alpha = 0;
		bg2018.setGraphicSize(Std.int(bg2018.width * 2));
		bg2018.updateHitbox();
		add(bg2018);

		bg2019 = new FlxSprite(-50, -225).loadGraphic(Paths.image('stage/tankmas2019_fullshot'));
		bg2019.antialiasing = true;
		bg2019.scrollFactor.set();
		bg2019.active = true;
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

		bg2021 = new FlxSprite(-80, -100).loadGraphic(Paths.image('stage/tankmas2021_fullshot'));
		bg2021.antialiasing = true;
		bg2021.scrollFactor.set();
		bg2021.active = false;
		bg2021.alpha = 0;
		bg2021.setGraphicSize(Std.int(bg2021.width * 1));
		bg2021.updateHitbox();
		add(bg2021);

		candle = new FlxSprite(100, 130);
		candle.frames = Paths.getSparrowAtlas('stage/candle');
		candle.animation.addByPrefix('flicker', 'candle flicker', 10, true);
		candle.antialiasing = false;
		candle.alpha = 0;
		candle.setGraphicSize(Std.int(candle.width * daPixelZoom));
		candle.updateHitbox();
		add(candle);

		garland = new FlxSprite(-154, -105);
		garland.frames = Paths.getSparrowAtlas('stage/garland');
		garland.animation.addByPrefix('light', 'garland light1', 1, true);
		garland.animation.addByPrefix('leet', 'garland light2', 1, true);
		garland.antialiasing = false;
		garland.setGraphicSize(Std.int(garland.width * 1.2));
		garland.updateHitbox();
		garland.alpha = 0;
		add(garland);

		gf = new Character(95, 10, 'gf');
		gf.antialiasing = false;
		gf.scrollFactor.set(1, 1);
		gf.setGraphicSize(Std.int(gf.width * 1.2));
		gf.updateHitbox();
		gf.alpha = 0;
		add(gf);

		fireplace = new FlxSprite(80, 60);
		fireplace.frames = Paths.getSparrowAtlas('stage/fireplace');
		fireplace.animation.addByPrefix('unlit', 'Fireplace Aint Lit Bro', 1, false);
		fireplace.animation.addByPrefix('lit', 'Fireplace Lit', 12, true);
		fireplace.antialiasing = false;
		fireplace.scrollFactor.set(1, 1);
		add(fireplace);
		
		dad = new Character(-25, 12, SONG.player2, Options.getUiOption('botplay') == true ? false : if (charInt == 0) true else false);

		var camPos:FlxPoint = new FlxPoint(bg.getGraphicMidpoint().x + 50, 85);

		boyfriend = new Boyfriend(138, 115, SONG.player1, Options.getUiOption('botplay') == true ? false : if (charInt == 1) true else false);

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

		//TESTING PURPOSES ONLY (as in these two dingleheads were turned off so I could align stuff)
		//dad.alpha = 0;
		//boyfriend.alpha = 0;

		lights = new FlxSprite(-180, -105).loadGraphic(Paths.image('stage/lights'));
		lights.antialiasing = true;
		lights.scrollFactor.set(1, 1);
		lights.active = false;
		lights.setGraphicSize(Std.int(lights.width * 1.4));
		lights.updateHitbox();
		add(lights);

		Boppers4 = new FlxSprite(-155, 105);
		Boppers4.frames = Paths.getSparrowAtlas('stage/fgcharfront');
		Boppers4.animation.addByPrefix('bop', "Front Characters Bop", 12, false);
		Boppers4.antialiasing = true;
		Boppers4.scrollFactor.set(1.05, 1);
		Boppers4.setGraphicSize(Std.int(Boppers4.width * 1.2));
		Boppers4.updateHitbox();
		Boppers4.alpha = 0;
		add(Boppers4);
		daBoppers.push(Boppers4);

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

		strumLine = new FlxSprite(0, Options.getUiOption('downscroll') ? 250 : 0).makeGraphic(Global.width, 10);
		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

		generateSong(SONG.song); //why did I change it to read 'spiritoftankmas' only when I loaded it up already in the CharSelect file

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

		scoreBar = new FlxBar(((Global.width) / 2) - 120, 280, LEFT_TO_RIGHT, 240, 15, null, "", 0, 1);
		scoreBar.createFilledBar(GameGlobal.getColor('outline'), GameGlobal.getColor('fill'), true, GameGlobal.getColor('outline'));
		scoreBar.scrollFactor.set();
		if (!Options.getUiOption('hidetime')) add(scoreBar);

		timeText = new FlxText((Global.width) / 2, 280, 0, FlxStringUtil.formatTime(Math.floor(FlxG.sound.load(Paths.inst(PlayState.SONG.song)).length) / 1000));
		timeText.setFormat(Paths.font('upheaval-pro-regular'), 13, GameGlobal.getColor('fill'), CENTER, OUTLINE, GameGlobal.getColor('outline'));
		timeText.x -= timeText.width / 2;
		timeText.y += 2;
		timeText.scrollFactor.set();
		if (!Options.getUiOption('hidetime')) add(timeText);

		autoText = new FlxText((Global.width) / 2, 30, 0, "");
		autoText.setFormat(Paths.font('upheaval-pro-regular'), 40, GameGlobal.getColor('fill'), CENTER, OUTLINE, GameGlobal.getColor('outline'));
		autoText.scrollFactor.set();
		add(autoText);

		if (Options.getUiOption('botplay') || Options.getUiOption('practice')) {
			autoText.text = Options.getUiOption('botplay') ? "BOTPLAY" : "PRACTICE";
			autoText.x -= (autoText.width / 2) - 5;
		}

		scoreTxt = new FlxText((Global.width) / 2, 270, 0, "", 20);
		scoreTxt.setFormat(Paths.font('upheaval-pro-regular'), 15, GameGlobal.getColor('fill'), CENTER, OUTLINE, GameGlobal.getColor('outline'));
		scoreTxt.scrollFactor.set();
		if (!Options.getUiOption('hidescore')) add(scoreTxt);

		//additional quick swap moment
		if(Options.getUiOption('downscroll')) {
			timeText.y += Global.height - (timeText.y * 2);
			scoreBar.y += Global.height - (scoreBar.y * 2);
			autoText.y += Global.height - (autoText.y * 2);
			scoreTxt.y += Global.height - (scoreTxt.y * 2);
		}
		
		//quick fix moment
		hudOverlay = new FlxTypedGroup<FlxBasic>();
		hudOverlay.camera = Global.camera;
		camHUD = hudOverlay.camera;

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		scoreBar.cameras = [camHUD];
		timeText.cameras = [camHUD];

		startingSong = true;
		startCountdown();

		super.create();

		FlxTween.tween(autoText, { alpha: 0 }, 1.5, { type: PINGPONG });
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{

		if (Options.getUiOption('middlescroll'))
		{
			generateStaticArrows(charInt, true);
		} else {
			generateStaticArrows(0, if(charInt == 0) true else false);
			generateStaticArrows(1, if(charInt == 1) true else false);
		}

		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');
			fireplace.animation.play('unlit', true);

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), Options.inGameSoundVolume() * 0.6);
					for (boppy in daBoppers) boppy.animation.play('bop', true);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/${introAlts[0]}'));
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
					FlxG.sound.play(Paths.sound('intro2'), Options.inGameSoundVolume() * 0.6);
					for (boppy in daBoppers) boppy.animation.play('bop', true);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/${introAlts[1]}'));
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
					FlxG.sound.play(Paths.sound('intro1'), Options.inGameSoundVolume() * 0.6);
					for (boppy in daBoppers) boppy.animation.play('bop', true);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/${introAlts[2]}'));
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
					FlxG.sound.play(Paths.sound('introGo'), Options.inGameSoundVolume() * 0.6);
					for (boppy in daBoppers) boppy.animation.play('bop', true);
				case 4:
					for (boppy in daBoppers) boppy.animation.play('bop', true);
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
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), Options.inGameMusicVolume(), false);
		FlxG.sound.music.onComplete = endSong;
		for(vox in vocals) {
			vox.volume = Options.inGameMusicVolume();
			vox.play();
		}

		candle.animation.play('flicker', true);
	};

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
		{

			var songData = SONG;
			Conductor.changeBPM(songData.bpm);
			vocals = new Array<FlxSound>();
	
			curSong = songData.song;
	
			if (SONG.needsVoices) {
				curVocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song, charInt == 1 ? 'bf' : 'dd'));
				oppVocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song, charInt == 1 ? 'dd' : 'bf'));
			} else {
				curVocals = new FlxSound();
				oppVocals = new FlxSound();
			}
	
			FlxG.sound.list.add(curVocals);
			FlxG.sound.list.add(oppVocals);

			vocals.push(curVocals);
			vocals.push(oppVocals);
	
			notes = new FlxTypedGroup<Note>();
			add(notes);
	
			var noteData:Array<SwagSection>;

			noteData = songData.notes;
	
			var playerCounter:Int = 0;
	
			var daBeats:Int = 0;
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
	
						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / 2), daNoteData, oldNote, gottaHitNote, true);
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);
						if (Options.getUiOption('middlescroll')) {
							if (charInt == 0) sustainNote.x += 120 else sustainNote.x -= 120;
						}
	
						sustainNote.mustPress = gottaHitNote;
	
						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2;
						}
					}
	
					swagNote.mustPress = gottaHitNote;
	
					if (Options.getUiOption('middlescroll'))
					{
						if (charInt == 0) swagNote.x += 120 else swagNote.x -= 120;
						if (swagNote.mustPress) swagNote.x += FlxG.width / 2;
					}
					else {
						if (swagNote.mustPress) swagNote.x += FlxG.width / 2;
					}
				}
				daBeats += 1;
			}
	
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

			if (isPlayerStrum && !Options.getUiOption('botplay'))
			{
				playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 33;
			if (!Options.getUiOption('middlescroll')) babyArrow.x += ((Global.width / 2) * player) else {
				babyArrow.x += Std.int(Global.width / 4);
			}

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
		{
			if (paused || afk)
			{
				if (FlxG.sound.music != null)
				{
					FlxG.sound.music.pause();
					for(vox in vocals) vox.pause();
				}
	
				if (!startTimer.finished)
					startTimer.active = false;
			}
	
			super.openSubState(SubState);
		}
	
		override function closeSubState()
		{
			if (paused || afk)
			{
				if (FlxG.sound.music != null && !startingSong)
				{
					resyncVocals();
				}
	
				if (!startTimer.finished)
					startTimer.active = true;
				paused = false;
			}
	
			super.closeSubState();
		}

	function resyncVocals():Void
	{
		for(vox in vocals) vox.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		for(vox in vocals) {
			vox.time = Conductor.songPosition;
			vox.play();
		}
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

		scoreTxt.text = "Combo Breaks: " + comboBreak + " | Current Rating: " + ratingTxt;
		scoreTxt.screenCenter(X);

		scoreBar.value = FlxG.sound.music.time / FlxG.sound.music.length;
		timeText.text = FlxStringUtil.formatTime((FlxG.sound.music.length - FlxG.sound.music.time) / 1000);

		if (Controls.justPressed.PAUSE && startedCountdown && canPause && !afk)
			{
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;

				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}

			//needed this for testing purposes and idk how the if debug statements work
			//if(Controls.justPressed.B) endSong();

			if(negativeCombo >= 100) {
				negativeAmount++;
				persistentUpdate = false;
				persistentDraw = true;
				afk = true;
				trace(negativeAmount);

				openSubState(new AFKSubState(negativeAmount));
				negativeCombo = 0;
				afk = false;
			}

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

			}

			if (camFollow.x != dad.getMidpoint().x + 100 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 90, dad.getMidpoint().y - 60);
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 60, boyfriend.getMidpoint().y - 85);
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
				case 159, 160:
					Boppers1.alpha += 0.02;
					gf.alpha += 0.02;
				case 288, 289:
					dad.alpha -= 0.003;
					boyfriend.alpha -= 0.003;
				case 290, 291:
					Boppers2.alpha += 0.02;
					dad.alpha -= 0.003;
					boyfriend.alpha -= 0.003;
				case 292:
					fireplace.animation.play('lit', true);
				case 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307:
					dad.alpha += 0.001;
					boyfriend.alpha += 0.001;
					dad.alpha += 0.001;
					boyfriend.alpha += 0.001;
				case 452, 453:
					Boppers3.alpha += 0.02;
				case 580:
					sky.alpha -= 0.2;
					mountains.alpha -= 0.2;
					bg.alpha -= 0.2;
					lights.alpha -= 0.2;
					candle.alpha += 0.2;
					shader.alpha += 0.2;
					for (boppy in daBoppers) boppy.alpha -= 0.2;
					gf.alpha -= 0.2;
					fireplace.alpha -= 0.2;
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
					bopSpeed = 0.5;
					garland.alpha = 1;
					fireplace.alpha = 1;
					for (boppy in daBoppers) boppy.alpha = 1;
					gf.alpha = 1;
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
					bopSpeed = 1;
					camZooming = false;
					inZoomProgress = true;
					tom.alpha = 1;
					for (boppy in daBoppers) boppy.alpha -= 0.001;
					gf.alpha -= 0.001;
				case 740, 741, 742, 743, 744, 745, 746, 747:
					var overallFade:Float = 0.005;
					sky.alpha -= overallFade;
					mountains.alpha -= overallFade;
					bg.alpha -= overallFade;
					lights.alpha -= overallFade;
					garland.alpha -= overallFade;
					boyfriend.alpha -= overallFade;
					dad.alpha -= overallFade;
					fireplace.alpha -= overallFade;
				case 748, 749, 750, 751:
					strumLineNotes.forEach((note) -> {
						note.alpha -= 0.02;
					});
					scoreTxt.alpha -= 0.02;
					scoreBar.alpha -= 0.02;
					timeText.alpha -= 0.02;
					tom.alpha -= 0.01;
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
				if ((!Options.getUiOption('downscroll') && daNote.y > Global.height) || (Options.getUiOption('downscroll') && daNote.y < -(Global.height)))
				{
					daNote.active = false;
					daNote.visible = false;
				} else {
					if (Options.getUiOption('middlescroll') && !daNote.mustPress) daNote.visible = false else daNote.visible = true;
					daNote.active = true;
				}

				if (!Options.getUiOption('downscroll')) daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2))) else daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

				if ((!Options.getUiOption('downscroll') && daNote.isSustainNote
					&& daNote.y + daNote.offset.y <= strumLine.y + strumLine.height + Note.swagWidth / 2
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit)))))
				{
					var swagRect = new FlxRect(0, 0, daNote.width * 2, daNote.height * 2);
					swagRect.y /= daNote.scale.y;
					swagRect.height -= swagRect.y;

					daNote.clipRect = swagRect;
				} else if (Options.getUiOption('downscroll') && daNote.isSustainNote
				&& daNote.y - daNote.offset.y >= strumLine.y + Note.swagWidth / 2
				&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					var swagRect = new FlxRect(0, strumLine.y - Note.swagWidth / 2 + daNote.y, daNote.width * 2, daNote.height * 2);
					swagRect.y /= daNote.scale.y;
					swagRect.height += swagRect.y;

					daNote.clipRect = swagRect;
				}

				if(Options.getUiOption('botplay') && ((!daNote.mustPress && daNote.wasGoodHit) || (daNote.mustPress && daNote.canBeHit))) {
					if(!daNote.mustPress && daNote.wasGoodHit) switch (Math.abs(daNote.noteData))
					{
						case 0:
							oppChar.playAnim('singLEFT', true);
						case 1:
							oppChar.playAnim('singDOWN', true);
						case 2:
							oppChar.playAnim('singUP', true);
						case 3:
							oppChar.playAnim('singRIGHT', true);
					}
					else if(daNote.mustPress && daNote.canBeHit) switch (Math.abs(daNote.noteData))
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
					oppChar.holdTimer = 0;
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
				else if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (!inZoomProgress) camZooming = true;

					var altAnim:String = "";

					switch (Math.abs(daNote.noteData))
					{
						case 0:
							oppChar.playAnim('singLEFT', true);
						case 1:
							oppChar.playAnim('singDOWN', true);
						case 2:
							oppChar.playAnim('singUP', true);
						case 3:
							oppChar.playAnim('singRIGHT', true);
					}

					oppChar.holdTimer = 0;
					oppVocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				if (((daNote.y < -daNote.height && !Options.getUiOption('downscroll')) || (daNote.y > FlxG.height + daNote.height && Options.getUiOption('downscroll'))))
				{
					{
						if (!Options.getUiOption('botplay')) curVocals.volume = 0;
						switch (daNote.noteData) {
							case 0:
								noteMiss(0);
							case 1:
								noteMiss(1);
							case 2:
								noteMiss(2);
							case 3:
								noteMiss(3);
						}
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}
			if(!Options.getUiOption('botplay')) keyShit();
	}

	function endSong():Void
	{
		canPause = false;
		FlxG.sound.music.volume = 0;
		for(vox in vocals) vox.volume = 0;

			trace('SONG COMPLETE');
			FlxG.sound.music.stop();
			Global.switchState(Options.getUiOption('botplay') ? new BotplayGameOverState() : new GameOverState());
	}
	var endingSong:Bool = false;

	private function popUpScore(strumtime:Float):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		curVocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(85, 0, 0, placement, 32);

		var rating:FlxSprite = new FlxSprite();
		rating.cameras = [camHUD];

		var daRating:String = "sweet";

		if (noteDiff > Conductor.safeZoneOffset * 0.6)
		{
			daRating = 'grinchy';
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.4)
		{
			daRating = 'naughty';
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.15)
		{
			daRating = 'nice';
		}

		var scoreArray = Options.scoreMap.get(daRating);

		songScore += Std.int(scoreArray[0] * (1 + FlxMath.roundDecimal(Math.floor(combo / 10) / 100, 2)));
		trace(FlxMath.roundDecimal(Math.floor(combo / 10) % 10, 2));
		ratingTxt = Rating.getRating(Std.int(songScore));
		scoreTxt.x = (Global.width / 2) - (scoreTxt.width / 2);
		Rating.addRatingAmount(daRating);

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
		insert(members.indexOf(strumLineNotes), rating);

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
			numScore.cameras = [camHUD];
			numScore.screenCenter();
			numScore.x = coolText.x + (30 * daLoop) + 10;
			numScore.y += 10;
			numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10)
				insert(members.indexOf(strumLineNotes), numScore);

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

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		if ((upP || rightP || downP || leftP) && !curChar.stunned && generatedMusic)
		{
			curChar.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
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
				else
				{
					noteCheck(controlArray[daNote.noteData], daNote);
				}
			}
			else
			{
				if (!Options.getUiOption('practice')) badNoteCheck();
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

	function noteMiss(direction:Int = 1, ?ghostPress:Bool = false):Void
	{
		if (!curChar.stunned)
		{
			var controlPress:Bool = false;
			switch (direction) {
				case 0:
					controlPress = Controls.pressed.LEFT;
				case 1:
					controlPress = Controls.pressed.UP;
				case 2:
					controlPress = Controls.pressed.DOWN;
				case 3:
					controlPress = Controls.pressed.RIGHT;
					
			}
			if(!ghostPress && !controlPress) {
					combo = 0;
					comboBreak += 1;
					negativeCombo += 1; 
			} else {
				negativeCombo = 0;
				negativeAmount = 0;
			}

			songScore -= 10;
			ratingTxt = Rating.getRating(Std.int(songScore));
			scoreTxt.x = (Global.width / 2) - (scoreTxt.width / 2);

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2) * Options.inGameSoundVolume());

			curChar.stunned = true;

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
		var upP = Controls.justPressed.UP;
		var rightP = Controls.justPressed.RIGHT;
		var downP = Controls.justPressed.DOWN;
		var leftP = Controls.justPressed.LEFT;

		if (leftP)
			noteMiss(0, true);
		if (downP)
			noteMiss(1, true);
		if (upP)
			noteMiss(2, true);
		if (rightP)
			noteMiss(3, true);
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
				negativeCombo = 0;
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
			curVocals.volume = 1;

			if(Math.abs(note.strumTime - Conductor.songPosition) < Conductor.safeZoneOffset * 0.15) {
				var noteForSplash = playerStrums.members[note.noteData];

				var splash = new FlxSprite();
				splash.cameras = [camHUD];

				splash.x = noteForSplash.x + (noteForSplash.width / 2) - (splash.width / 2) - 57;
				splash.y = noteForSplash.y + (noteForSplash.height / 2) - (splash.height / 2) - 40;
				splash.scrollFactor.set();

				splash.frames = Paths.getSparrowAtlas('ui/notesplash');
				splash.animation.addByPrefix('green1', 'notesplash green 1', 12, false);
				splash.animation.addByPrefix('green2', 'notesplash green 2', 12, false);
				splash.animation.addByPrefix('red1', 'notesplash red 1', 12, false);
				splash.animation.addByPrefix('red2', 'notesplash red 2', 12, false);

				insert(members.indexOf(camFollow), splash);
				var isEven:Bool = false;
				if(note.noteData == 1 || note.noteData == 3) isEven = true;
				splash.animation.play(isEven ? 'red${FlxG.random.int(1, 2)}' : 'green${FlxG.random.int(1, 2)}');
				var timer = new FlxTimer().start(0.33, function(tmr:FlxTimer) { splash.destroy(); }, 1);
			}

			//if (!note.isSustainNote)
			//{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			//}
		}
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (curStep % (4 * bopSpeed) == 0)
			{
				for (boppy in daBoppers) boppy.animation.play('bop', true);
				if(garlandFrame == 1) {
					garlandFrame = 0;
					garland.animation.play('light', true);
				} else {
					garlandFrame = 1;
					garland.animation.play('leet', true);
				}
				gf.dance();
			}
	}

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, Options.getUiOption('downscroll') ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			//if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				//if(charInt == 0) oppChar.playAnim('idle', true) else oppChar.dance();
		}

		if (camZooming && Global.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			Global.camera.zoom += 0.015;
		}

		if (!curChar.animation.curAnim.name.startsWith("sing"))
		{
			if(charInt == 1) curChar.playAnim('idle') else curChar.dance();
		}

		if (!oppChar.animation.curAnim.name.startsWith("sing"))
			{
				if(charInt == 0) oppChar.playAnim('idle') else oppChar.dance();
			}
	}
}