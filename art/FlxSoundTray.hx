package flixel.system.ui;

#if FLX_SOUND_SYSTEM
import flixel.FlxG;
import openfl.display.Bitmap;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.utils.Assets;
import openfl.Lib;

import haxe.Timer;

class FlxSoundTray extends Sprite {
	public var active:Bool = false;

	var volumeText:TextField;

	var bar:Shape;
	var tim:Timer;

	public function new():Void {
		super();
		
		final bg = new Shape();
		bg.graphics.beginFill(0x93BCFF, 1);
		bg.graphics.drawRect(75, 10, 165, 15);
		bg.graphics.endFill();
		addChild(bg);

		addChild(bar = new Shape());

		final overlay = new Bitmap(Assets.getBitmapData(Path.get('images/ui/soundbg.png')));
		overlay.smoothing = overlay.cacheAsBitmap = true;
		addChild(overlay);

		addChild(volumeText = new TextField());
		volumeText.defaultTextFormat = new TextFormat(Assets.getFont('assets/data/fonts/FallingSkyBlk.otf').fontName, 18, 0xFFFFFF);
		volumeText.selectable = volumeText.mouseEnabled = false;
		volumeText.autoSize = CENTER;
		volumeText.width = 50;

		volumeText.x = 11;
		volumeText.y = 3;

		y = 10;

		visible = false;

		screenCenter();
	}

	public function redrawBar():Void {
		bar.graphics.clear();
		bar.graphics.beginFill(0xFFFFFF, 1);
		bar.graphics.drawRect(75, 10, 165 * (FlxG.sound.muted ? 0 : FlxG.sound.volume), 15);
		bar.graphics.endFill();
	}

	public function update(elapsed:Float):Void {}

	public function screenCenter():Void {
		x = (0.5 * (Lib.current.stage.stageWidth - 248) - FlxG.game.x);
		redrawBar();
	}

	public function show(up:Bool = false):Void {
		if (FlxG.save.isBound) {
			FlxG.save.data.mute = FlxG.sound.muted;
			FlxG.save.data.volume = FlxG.sound.volume;
			FlxG.save.flush();
		}

		final theVolume = Math.round(FlxG.sound.volume * 100);

		final pitchS = FlxG.sound.load(Path.sound(theVolume == 100 ? 'volumeMax' : (up ? 'volumeUp' : 'volumeDown')));
		pitchS.play();

		volumeText.text = '${FlxG.sound.muted ? 0 : theVolume}%';

		redrawBar();

		active = visible = true;

        dispose();
        tim = Timer.delay(hide, 1000);
	}

	function hide():Void {
		active = visible = false;
		dispose();
	}

	public function dispose():Void {
		if (tim == null) return;

		tim.stop();
		tim = null;
	}
}
#end