package flixel.system.ui;

#if FLX_SOUND_SYSTEM
import flixel.FlxG;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.display.Shape;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import haxe.Timer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.utils.Assets;

class FlxSoundTray extends Sprite {

	public var active:Bool;
	private var hideTimer:Timer;
	var volumeText:TextField;

	public function new() {
		super();

		volumeText = new TextField();
		volumeText.y = 7;
		volumeText.x = 4;
		volumeText.multiline = false;
		volumeText.wordWrap = false;
		volumeText.selectable = false;

		volumeText.defaultTextFormat = new TextFormat(Assets.getFont("assets/fonts/FallingSkyBd.otf").fontName, 16, 0xFFFFFF);
		volumeText.defaultTextFormat.align = TextFormatAlign.LEFT;
		addChild(volumeText);
		volumeText.text = "0%";

		x = 7;
		y = 7;
		active = visible = false;

		screenCenter();
	}

	public function redrawBar() {
		graphics.clear();
		graphics.beginFill(0xFF004799, 1);
		graphics.drawRoundRect(0, 0, FlxG.stage.window.width / 4 - 16, 35, 0);
		graphics.endFill();

		graphics.beginFill(0x93BCFF, 1);
		graphics.drawRoundRect(volumeText.textWidth + 18, 6, (width - volumeText.textWidth - 44), 35 - 12, 0);
		graphics.endFill();

		graphics.beginFill(0xFFFFFF, 1);
		graphics.drawRoundRect(volumeText.textWidth + 18, 6, (width - volumeText.textWidth - 44) * (FlxG.sound.muted ? 0 : FlxG.sound.volume), 35 - 12, 0);
		graphics.endFill();
	}

	public function update(delta:Float):Void {}

	public function screenCenter() {
		volumeText.width = FlxG.stage.window.width / 4;
		redrawBar();
	}

	public function show(up:Bool = false):Void {
		active = visible = true;
		if (FlxG.save.isBound) {
			FlxG.save.data.mute = FlxG.sound.muted;
			FlxG.save.data.volume = FlxG.sound.volume;
			FlxG.save.flush();
		}

		FlxG.sound.load(Paths.sound((up ? 'volumeUp' : 'volumeDown'))).play();

		volumeText.text = '${Math.round(FlxG.sound.volume * 100) * (FlxG.sound.muted ? 0 : 1)}%';
		redrawBar();
		timeout();
	}

    function timeout() {
		active = visible = true;
		hideTimer?.stop();
		hideTimer = Timer.delay(() -> {
			active = visible = false;
		}, 1000);
		return;
	}
}
#end