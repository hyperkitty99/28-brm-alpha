package states;

import flixel.addons.display.FlxBackdrop;
import shaders.ShutterEffect;

class MainMenuState extends MusicBeatState {
	public static var curSelected = 0;

	final itemShit:Array<Dynamic> = [{name: 'static', pos: [302, 110]}, {name: 'pc', pos: [-553, -6]}, {name: 'light', pos: [-214, 2]}, {name: 'cd', pos: [785, 826]}];
	var items:FlxTypedGroup<BGSprite>;

	final itemUI:Array<Dynamic> = [{name: 'fys', pos: [-84, 218]}, {name: 'iccer', pos: [1280, 94]}, {name: 'robot-dolbaeb', pos: [469, 157]}];
	var itemsUI:FlxTypedGroup<BGSprite>;

	var buttonHitbox:BGSprite;
	var blackL:FlxSprite;
	var blackR:FlxSprite;

	var trigFYS:FlxBackdrop;
	var trigICCER:FlxBackdrop;

	var discCollected = false;
	var pcOn = false;
	var noise:FlxSound;

	var mCam:FlxCamera;
	var uiCam:FlxCamera;
	var gradient:FlxSprite;

	override function create() {
		transIn = flixel.addons.transition.FlxTransitionableState.defaultTransIn;
		transOut = flixel.addons.transition.FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		FlxG.mouse.visible = true;

		mCam = initPsychCamera();

		uiCam = new FlxCamera();
		uiCam.bgColor.alpha = 0;
		FlxG.cameras.add(uiCam, false);

		noise = new FlxSound();
		noise.loadEmbedded(Paths.music('noise'), true, true);
		noise.volume = 0;
		noise.play(false);

		add(gradient = flixel.util.FlxGradient.createGradientFlxSprite(2688, 1512, [0xFF0D0E18, 0xFF06060D]));
		gradient.scrollFactor.set();
		gradient.screenCenter();

		add(items = new FlxTypedGroup());
		for (i in 0...itemShit.length) items.add(new BGSprite('ui/mainmenu/${itemShit[i].name}', itemShit[i].pos[0], itemShit[i].pos[1], itemShit[i].name == 'static' ? ['static'] : null, true));

		add(blackL = new FlxSprite().makeGraphic(200, FlxG.height, 0x66000000));
		add(blackR = new FlxSprite(1280).makeGraphic(200, FlxG.height, 0x66000000));

		add(trigFYS = new FlxBackdrop(Paths.image('ui/mainmenu/trig'), Y));
		trigFYS.x = -8;
		trigFYS.velocity.y = 40;

		add(trigICCER = new FlxBackdrop(Paths.image('ui/mainmenu/trig'), Y));
		trigICCER.flipX = true;
		trigICCER.x = 1280;
		trigICCER.velocity.y = -40;

		add(itemsUI = new FlxTypedGroup());
		for (i in 0...itemUI.length) itemsUI.add(new BGSprite('ui/mainmenu/${itemUI[i].name}', itemUI[i].pos[0], itemUI[i].pos[1]));

		blackL.camera = blackR.camera = trigFYS.camera = trigICCER.camera = itemsUI.camera = uiCam;

		add(buttonHitbox = new BGSprite('ui/mainmenu/blue', 255, 617));

		super.create();
	}

	var woosh = false;

	//TODO: REDO THIS RETARDED LOGIC CUZ DAMN THIS IS BAD
	var robotPos = [271, 825];

	var trigICCERPos = 1280;
	var trigFYSPos = -314;

	var iccerPos = 1280;
	var fysPos = -504;

	var blackLPos = -200;
	var blackRPos = 1280;

	var stupid:ShutterEffect = new ShutterEffect();
	override function update(elapsed:Float) {
		if (FlxG.sound.music.volume < 0.8) FlxG.sound.music.volume += 0.5 * elapsed;

		if (!woosh) {
			itemsUI.members[0].x = FlxMath.lerp(itemsUI.members[0].x, fysPos, 0.2);
			itemsUI.members[1].x = FlxMath.lerp(itemsUI.members[1].x, iccerPos, 0.2);
			itemsUI.members[2].x = FlxMath.lerp(itemsUI.members[2].x, robotPos[0], 0.1);
			itemsUI.members[2].y = FlxMath.lerp(itemsUI.members[2].y, robotPos[1], 0.1);

			trigFYS.x = FlxMath.lerp(trigFYS.x, trigFYSPos, 0.15);
			trigICCER.x = FlxMath.lerp(trigICCER.x, trigICCERPos, 0.15);

			blackL.x = FlxMath.lerp(blackL.x, blackLPos, 0.3);
			blackR.x = FlxMath.lerp(blackR.x, blackRPos, 0.3);
		}

		if (FlxG.mouse.overlaps(items.members[3]) && !discCollected && !pcOn) {
			items.members[3].color = 0xFFFFFFFF;

			if (FlxG.mouse.justPressed) {
				FlxTween.tween(items.members[3], {x: 955, y: 1008}, 0.2, {ease: FlxEase.circIn});
				discCollected = true;
			}
		} else items.members[3].color = pcOn ? 0xFFFFFFFF : 0xFF949494;

		pcOn ? noise.volume = !discCollected ? 0.2 : 0 : noise.volume = 0;

		if (FlxG.mouse.overlaps(buttonHitbox)) {
			if (!pcOn) buttonHitbox.visible = true;
			if (FlxG.mouse.justPressed) {
				buttonHitbox.visible = false;
				FlxG.sound.play(Paths.sound('click'));
				pcOn = !pcOn;
				woosh = false;
			} 
		} else buttonHitbox.visible = false;
		items.members[2].visible = items.members[0].active = pcOn;
		items.members[0].color = pcOn ? (!discCollected ? 0xFFFFFFFF : 0xFF000000) : 0xFF000000;

		if (!pcOn && discCollected && !woosh) {
			woosh = true;
			robotPos = [271, 825];

			trigICCERPos = 1280;
			trigFYSPos = -314;

			iccerPos = 1280;
			fysPos = -504;

			blackLPos = -200;
			blackRPos = 1280;

			FlxTween.tween(itemsUI.members[0], {x: fysPos}, 0.3, {ease: FlxEase.expoIn});
			FlxTween.tween(itemsUI.members[1], {x: iccerPos}, 0.3, {ease: FlxEase.expoIn});

			FlxTween.tween(trigFYS, {x: trigFYSPos}, 0.2, {ease: FlxEase.expoIn});
			FlxTween.tween(trigICCER, {x: trigICCERPos}, 0.2, {ease: FlxEase.expoIn});

			FlxTween.tween(blackL, {x: blackLPos}, 0.2, {ease: FlxEase.expoIn});
			FlxTween.tween(blackR, {x: blackRPos}, 0.2, {ease: FlxEase.expoIn});

			FlxTween.tween(itemsUI.members[2], {x: robotPos[0], y: robotPos[1]}, 0.25, {ease: FlxEase.expoIn});
		}

		if (pcOn && discCollected) {
			trigICCERPos = 986;
			trigFYSPos = -8;

			iccerPos = 882;
			fysPos = -84;

			blackLPos = 0;
			blackRPos = 1080;

			robotPos = [469, 157];

			if (FlxG.mouse.overlaps(itemsUI.members[2])) {
				if (FlxG.mouse.justPressed) {
					PlayState.SONG = backend.Song.loadFromJson('russophobia', 'russophobia');
					PlayState.isStoryMode = false;

					stupid.radius = 1500;
					stupid.shutterTargetMode = ShutterEffect.SHUTTER_TARGET_FLXCAMERA;

					if (uiCam.filters == null) uiCam.filters = [];
					uiCam.filters.push(new openfl.filters.ShaderFilter(stupid.shader));
					FlxTween.tween(stupid, {radius: 0}, 0.65, {ease: FlxEase.expoOut, onComplete: (_) -> {
						PlayState.retardCheck = true;
						FlxG.switchState(new states.PlayState());
						flixel.addons.transition.FlxTransitionableState.skipNextTransOut = true;
					}});

				} 
			}
		}

		if (controls.justPressed('debug_1')) {
			MusicBeatState.switchState(new states.editors.MasterEditorMenu());
		}

		if (FlxG.camera.target == null) {
			final point = [FlxMath.bound(FlxG.mouse.screenX, 0, FlxG.width), FlxMath.bound(FlxG.mouse.screenY, 0, FlxG.height)];
			FlxG.camera.scroll.set(
				FlxMath.lerp((point[0] * FlxG.camera.zoom) * 0.035, FlxG.camera.scroll.x, Math.exp(-elapsed * 25)), 
				FlxMath.lerp((point[1] * FlxG.camera.zoom) * 0.05, FlxG.camera.scroll.y, Math.exp(-elapsed * 25))
			);

			FlxG.camera.zoom = 0.6 - (Math.pow(Math.abs(FlxMath.remapToRange(point[0] - items.members[1].x, 0, items.members[1].width, -0.25, 0.25)), 2) + Math.pow(Math.abs(FlxMath.remapToRange(point[1] - items.members[1].y, 0, items.members[1].height, -0.2, 0.2)), 2)) * 0.5;
		}

		super.update(elapsed);
	}
}