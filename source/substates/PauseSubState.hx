package substates;

import flixel.addons.transition.FlxTransitionableState;	
import flixel.util.FlxStringUtil;

class PauseSubState extends MusicBeatSubstate {
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [getLocalizedString("resume"), getLocalizedString("restart_song"), getLocalizedString("options"), getLocalizedString("exit_to_menu")];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var skipTimeText:FlxText;
	var skipTimeTracker:Alphabet;
	var curTime:Float = Math.max(0, Conductor.songPosition);

	public static var songName:String = null;

	override function create() {
		if(states.PlayState.chartingMode) {
			menuItems.insert(2, getLocalizedString("leave_charting_mode"));
			
			var num:Int = 0;
			if(!states.PlayState.instance.startingSong) {
				num = 1;
				menuItems.insert(3, getLocalizedString("skip_time"));
			}
			menuItems.insert(3 + num, getLocalizedString("end_song"));
		}


		pauseMusic = new FlxSound();
        pauseMusic.loadEmbedded(Paths.music('Breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		add(bg);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		regenMenu();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		super.create();
	}

	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float) {
		cantUnpause -= elapsed;
		if (pauseMusic.volume < 0.5) pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		if(controls.BACK) {
			close();
			return;
		}

		updateSkipTextStuff();
		if (controls.UI_UP_P || controls.UI_DOWN_P) changeSelection(controls.UI_UP_P ? -1 : 1);

		var daSelected:String = menuItems[curSelected];
		switch (daSelected) {
			case 'Skip Time' | 'öìëõóúøÿ ãôåïӫ':
				if (controls.UI_LEFT_P || controls.UI_RIGHT_P) {
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					controls.UI_LEFT_P ? curTime -= 1000 : curTime += 1000;
					holdTime = 0;
				}

				if(controls.UI_LEFT || controls.UI_RIGHT) {
					holdTime += elapsed;
					if(holdTime > 0.5) curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);

					if(curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;
					else if(curTime < 0) curTime += FlxG.sound.music.length;
					updateSkipTimeText();
				}
		}

		if (controls.ACCEPT && (cantUnpause <= 0 || !controls.controllerMode)) {
			switch (daSelected) {
				case "Resume" | "õôòäòîèëøÿ":
					close();
				case "Restart Song" | "óáçáøÿ öóòãá":
					restartSong();
				case "Leave Charting Mode" | "õòìëóúøÿ charting mode":
					restartSong();
					states.PlayState.chartingMode = false;
				case 'Skip Time' | 'öìëõóúøÿ ãôåïӫ':
					if(curTime < Conductor.songPosition) {
						states.PlayState.startOnTime = curTime;
						restartSong(true);
					} else {
						if (curTime != Conductor.songPosition) {
							states.PlayState.instance.clearNotesBefore(curTime);
							states.PlayState.instance.setSongTime(curTime);
						}
						close();
					}
				case 'End Song' | 'êáãåôæëøÿ õåöóß':
					close();
					states.PlayState.instance.notes.clear();
					states.PlayState.instance.unspawnNotes = [];
					states.PlayState.instance.finishSong(true);
				case 'Options' | 'óáöøôòíìë':
					states.PlayState.instance.paused = true;
					states.PlayState.instance.vocals.volume = 0;

					MusicBeatState.switchState(new options.OptionsState());

					FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath('Breakfast')), pauseMusic.volume);
					FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
					FlxG.sound.music.time = pauseMusic.time;

					options.OptionsState.onPlayState = true;
				case "Exit to menu" | "ãłíøë ã ïåóß":
					#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
					states.PlayState.deathCounter = 0;
					states.PlayState.seenCutscene = false;

					states.PlayState.isStoryMode ? MusicBeatState.switchState(new states.StoryMenuState()) : MusicBeatState.switchState(new states.MainMenuState());

					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					states.PlayState.chartingMode = false;
					FlxG.camera.followLerp = 0;
			}
		}
	}

	function deleteSkipTimeText()
	{
		if(skipTimeText != null)
		{
			skipTimeText.kill();
			remove(skipTimeText);
			skipTimeText.destroy();
		}
		skipTimeText = null;
		skipTimeTracker = null;
	}

	public static function restartSong(noTrans:Bool = false) {
		states.PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		states.PlayState.instance.vocals.volume = 0;

		if(noTrans) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
		}
		MusicBeatState.resetState();
	}

	override function destroy() {
		pauseMusic.destroy();
		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0) {
				item.alpha = 1;

				if(item == skipTimeTracker) {
					curTime = Math.max(0, Conductor.songPosition);
					updateSkipTimeText();
				}
			}
		}
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...menuItems.length) {
			var item = new Alphabet(90, 320, menuItems[i], true);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);

			if(menuItems[i] == getLocalizedString("skip_time")) {
				skipTimeText = new FlxText(0, 0, 0, '', 64);
				skipTimeText.setFormat(Paths.font("FallingSkyBd.otf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				skipTimeText.scrollFactor.set();
				skipTimeText.borderSize = 2;
				skipTimeTracker = item;
				add(skipTimeText);

				updateSkipTextStuff();
				updateSkipTimeText();
			}
		}
		curSelected = 0;
		changeSelection();
	}
	
	function updateSkipTextStuff() {
		if(skipTimeText == null || skipTimeTracker == null) return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 60;
		skipTimeText.y = skipTimeTracker.y;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText()
		skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
}
