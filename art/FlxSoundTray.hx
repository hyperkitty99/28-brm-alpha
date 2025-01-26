package flixel.system.ui;

#if FLX_SOUND_SYSTEM
import flixel.FlxG;
import openfl.display.Bitmap;
import openfl.text.TextField;
import openfl.text.TextFormat;

import haxe.Timer;

class FlxSoundTray extends openfl.display.Sprite {
	public var active = false;

	var volumeText:TextField;

	var bar:openfl.display.Shape;
	var tim:Timer;

	public function new() {
		super();
		
		final bg = new openfl.display.Shape();
		bg.graphics.beginFill(0x93BCFF, 1);
		bg.graphics.drawRect(75, 10, 165, 15);
		bg.graphics.endFill();
		addChild(bg);

		addChild(bar = new openfl.display.Shape());

		final overlay = new Bitmap(openfl.utils.Assets.getBitmapData(Path.get('images/ui/soundbg.png')));
		overlay.smoothing = true;
		overlay.cacheAsBitmap = true;
		addChild(overlay);

		addChild(volumeText = new TextField());

		volumeText.defaultTextFormat = new TextFormat(openfl.utils.Assets.getFont('assets/data/fonts/FallingSkyBlk.otf').fontName, 18, 0xFFFFFF);
		volumeText.selectable = volumeText.mouseEnabled = false;
		volumeText.autoSize = CENTER;
		volumeText.width = 50;

		volumeText.x = 11;
		volumeText.y = 3;

		y = 10;

		visible = false;

		screenCenter();
	}

	public function redrawBar() {
		bar.graphics.clear();
		bar.graphics.beginFill(0xFFFFFF, 1);
		bar.graphics.drawRect(75, 10, 165 * (FlxG.sound.muted ? 0 : FlxG.sound.volume), 15);
		bar.graphics.endFill();
	}

	public function update(elapsed:Float) {}

	public function screenCenter() {
		x = (0.5 * (openfl.Lib.current.stage.stageWidth - 248) - FlxG.game.x);
		redrawBar();
	}

	public function show(up = false) {
		if (FlxG.save.isBound) {
			FlxG.save.data.mute = FlxG.sound.muted;
			FlxG.save.data.volume = FlxG.sound.volume;
			FlxG.save.flush();
		}

		final theVolume = Math.round(FlxG.sound.volume * 100);

		final pitchS = FlxG.sound.load(Path.sound(theVolume == 100 ? 'volumeMax' : (up ? 'volumeUp' : 'volumeDown')));
		#if FLX_PITCH pitchS.pitch = flixel.math.FlxMath.lerp(0.55, 1, FlxG.sound.volume); #end
		pitchS.play();

		volumeText.text = '${FlxG.sound.muted ? 0 : theVolume}%';

		redrawBar();

		active = visible = true;

        dispose();
        tim = Timer.delay(() -> {active = visible = false; dispose();}, 1000);
	}

	public function dispose() {
		if (tim != null) {
			tim.stop();
			tim = null;
		}
	}
}
#end