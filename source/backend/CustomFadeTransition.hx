package backend;

class CustomFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void -> Void;
	var isTransIn = false;

	var duration:Float;
	public function new(duration:Float, isTransIn:Bool) {
		this.duration = duration;
		this.isTransIn = isTransIn;
		super();
	}

	override function create() {
		var transGradient:flixel.addons.display.FlxBackdrop; 
		add(transGradient = new flixel.addons.display.FlxBackdrop(Paths.image('sonic'), Y));

		if(isTransIn)
			FlxTween.tween(transGradient, {x: -FlxG.width - 49}, duration, {ease: FlxEase.circInOut, onComplete: (_) -> close()});
		else {
			transGradient.x = FlxG.width;
			transGradient.flipX = true;
			FlxTween.tween(transGradient, {x: -49}, duration, {ease: FlxEase.circInOut, onComplete: (_) -> {
				if(finishCallback != null) finishCallback();
				finishCallback = null;
			}});
		}

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		super.create();
	}
}