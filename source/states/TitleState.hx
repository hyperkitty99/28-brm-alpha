package states;

import backend.WeekData;
import backend.Highscore;

import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;

import openfl.display.Bitmap;
import openfl.display.BitmapData;

class TitleState extends MusicBeatState {
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

    var camHUD:FlxCamera;
	var camGame:FlxCamera;

	override public function create():Void {
		Paths.clearStoredMemory();

		camGame = initPsychCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.add(camHUD, false);

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		curWacky = FlxG.random.getObject(getIntroTextShit());

		super.create();

		FlxG.save.bind('funkin', CoolUtil.getSavePath());
		ClientPrefs.loadPrefs();
		Highscore.load();
		loadLocalizedLanguage(ClientPrefs.data.language);

		if(!initialized) {
			if(FlxG.save.data != null && FlxG.save.data.fullscreen) FlxG.fullscreen = FlxG.save.data.fullscreen;
			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null) states.StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;

		FlxG.mouse.visible = false;
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else
			initialized ? startIntro() : new FlxTimer().start(1, function(tmr:FlxTimer) {startIntro();});
	}

	var logoBl:FlxSprite;
	var titleText:FlxSprite;
	function startIntro() {
		if (!initialized) if(FlxG.sound.music == null) FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

		FlxSprite.defaultAntialiasing = ClientPrefs.data.antialiasing;
		Conductor.bpm = 50;
		persistentUpdate = true;

		var skys = new FlxSprite(0, 1094).loadGraphic(Paths.image('sky'));
		skys.scrollFactor.set(1, 0.4);
		add(skys);

		var mountainss = new FlxSprite(0, 3300).loadGraphic(Paths.image('mountains'));
		mountainss.scrollFactor.set(1, 0.6);
	    add(mountainss);

		var sky = new FlxSprite(0, -806).loadGraphic(Paths.image('sky'));
		sky.scrollFactor.set(1, 0.4);
		add(sky);

		var mountains = new FlxSprite(0, 451).loadGraphic(Paths.image('mountains'));
		mountains.scrollFactor.set(1, 0.6);
	    add(mountains);

		var factory = new FlxSprite(995, 992).loadGraphic(Paths.image('factory'));
		factory.scrollFactor.set(1, 0.7);
	    add(factory);

		var cityBG = new FlxSprite(0, 1429).loadGraphic(Paths.image('cityBG'));
		cityBG.scrollFactor.set(1, 0.8);
	    add(cityBG);

		var city = new FlxSprite(0, 1661).loadGraphic(Paths.image('city'));
		city.scrollFactor.set(1, 0.9);
	    add(city);

	    add(new FlxSprite(0, 2790).loadGraphic(Paths.image('hell')));

		var trans = new FlxSprite(0, 2982).loadGraphic(Paths.image('transitionRock'));
		trans.scrollFactor.set(1, 1.2);
	    add(trans);

		var dBar = new FlxSprite(0, FlxG.height - 75).makeGraphic(1280, 75, FlxColor.BLACK);
		add(dBar);
		var uBar = new FlxSprite().makeGraphic(1280, 75, FlxColor.BLACK);
		add(uBar);

		var logoBl = new FlxSprite().loadGraphic(Paths.image('logoBumpin'));
		logoBl.scale.set(0.6, 0.6);
		logoBl.updateHitbox();
		logoBl.screenCenter();
	    add(logoBl);

		add(credGroup = new FlxGroup());
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		ngSpr = new FlxSprite(0, FlxG.height * 0.44);
		ngSpr.frames = Paths.getSparrowAtlas('durka');
		ngSpr.animation.addByPrefix('logo', 'logo', 24, true);
		ngSpr.animation.play('logo', true);
		ngSpr.screenCenter(X);
		ngSpr.updateHitbox();
		ngSpr.antialiasing = ClientPrefs.data.antialiasing;
		ngSpr.visible = false;
		credGroup.add(ngSpr);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();
		credTextShit.visible = false;

		logoBl.cameras = [camHUD];
		dBar.cameras = [camHUD];
		uBar.cameras = [camHUD];
		ngSpr.cameras = [camHUD];
		credGroup.cameras = [camHUD];
		textGroup.cameras = [camHUD];

		initialized ? skipIntro() : initialized = true;

		Paths.clearUnusedMemory();
	}

	function getIntroTextShit():Array<Array<String>> {
		var fullText:String = File.getContent(Paths.txt('introText'));
		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray) swagGoodArray.push(i.split('--'));

		return swagGoodArray;
	}

	var transitioning:Bool = false;
	private static var playJingle:Bool = false;
	
	var newTitle:Bool = false;
	var titleTimer:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null) if (gamepad.justPressed.START) pressedEnter = true;
		
		if (newTitle) {
			titleTimer += FlxMath.bound(elapsed, 0, 1);
			if (titleTimer > 2) titleTimer -= 2;
		}

		if (initialized && !transitioning && skippedIntro)
		{
			if(pressedEnter)
			{
				WinAPI.setDarkMode(true);

				camHUD.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;

				new FlxTimer().start(1, function(tmr:FlxTimer) {
					MusicBeatState.switchState(new states.MainMenuState());
					closedState = true;
				});
			}
		}

		if (initialized && pressedEnter && !skippedIntro) skipIntro();

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			if(credGroup != null && textGroup != null) {
				credGroup.add(money);
				textGroup.add(money);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0) {
		if(textGroup != null && credGroup != null) {
			var coolText:Alphabet = new Alphabet(0, 0, text, true);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText() {
		while (textGroup.members.length > 0) {
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	public static var closedState:Bool = false;
	override function beatHit() {
		super.beatHit();

		if(!closedState) {
			sickBeats++;
			switch (sickBeats) {
				case 1:
					FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
					FlxG.sound.music.fadeIn(4, 0, 0.7);
				case 2:
					createCoolText(['28 BRM by'], 40);
				case 4:
					addMoreText('Iccer', 40);
					addMoreText('NickNGC', 40);
					addMoreText('lostel', 40);
					addMoreText('RoFos', 40);
					addMoreText('Rendan', 40);
				case 5:
					deleteCoolText();
				case 6:
					createCoolText(['Powered', 'by'], -75);
				case 8:
					addMoreText('Durkagrad', -75);
					ngSpr.visible = true;
				case 9:
					deleteCoolText();
					ngSpr.visible = false;
				case 10:
					createCoolText([curWacky[0]]);
				case 12:
					addMoreText(curWacky[1]);
				case 13:
					deleteCoolText();
				case 14:
					addMoreText('28');
				case 15:
					addMoreText('BRM');
				case 16:
					addMoreText('Season 1');
				case 17:
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;
	function skipIntro():Void {
		if (!skippedIntro) {
			remove(ngSpr);
			remove(credGroup);
			camHUD.flash(FlxColor.WHITE, 4);
			FlxTween.tween(camGame.scroll, {y: 4750}, 30, {ease: FlxEase.linear, type: LOOPING});
			skippedIntro = true;
		}
	}
}
