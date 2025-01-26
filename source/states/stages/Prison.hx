package states.stages;

import states.stages.objects.*;
// import objects.Character;

class Prison extends BaseStage {
	var speaker:FlxSprite;
	override function create()
	{
		var bg:BGSprite = new BGSprite('bgs/prison/prison', -492, -196, 0.9, 0.9);
		add(bg);

		var staticc:FlxSprite = new FlxSprite(931, 696);
		staticc.frames = Paths.getSparrowAtlas('bgs/prison/staticc');
		staticc.animation.addByPrefix('staticc', 'staticc', 24, true);
		staticc.animation.play('staticc', true);
		staticc.scrollFactor.set(0.9, 0.9);
		staticc.antialiasing = ClientPrefs.data.antialiasing;
		staticc.updateHitbox();
		add(staticc);

		speaker = new FlxSprite(896, 619);
		speaker.frames = Paths.getSparrowAtlas('bgs/prison/speaker');
		speaker.animation.addByPrefix('speaker', 'speaker', 24, false);
		speaker.scrollFactor.set(0.9, 0.9);
		speaker.antialiasing = ClientPrefs.data.antialiasing;
		speaker.updateHitbox();
		add(speaker);

		var monitorFore:BGSprite = new BGSprite('bgs/prison/monitorFore', -442 * 1.5, 628 * 1.5, 1.5, 1.5);
		add(monitorFore);

		var marijuana:BGSprite = new BGSprite('bgs/prison/marijuana', 1678 * 1.5, 633 * 1.5, 1.5, 1.5);
		add(marijuana);
	}

	override function beatHit() {
		super.beatHit();
		if(speaker != null) speaker.animation.play('speaker', true);
	}
	// override function eventPushed(event:objects.Note.EventNote)
	// {
	// 	switch(event.event)
	// 	{
	// 		case "Dadbattle Spotlight":
	// 			dadbattleBlack = new BGSprite(null, -800, -400, 0, 0);
	// 			dadbattleBlack.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
	// 			dadbattleBlack.alpha = 0.25;
	// 			dadbattleBlack.visible = false;
	// 			add(dadbattleBlack);

	// 			dadbattleLight = new BGSprite('spotlight', 400, -400);
	// 			dadbattleLight.alpha = 0.375;
	// 			dadbattleLight.blend = ADD;
	// 			dadbattleLight.visible = false;
	// 			add(dadbattleLight);

	// 			dadbattleFog = new DadBattleFog();
	// 			dadbattleFog.visible = false;
	// 			add(dadbattleFog);
	// 	}
	// }

	// override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	// {
	// 	switch(eventName)
	// 	{
	// 		case "Dadbattle Spotlight":
	// 			if(flValue1 == null) flValue1 = 0;
	// 			var val:Int = Math.round(flValue1);

	// 			switch(val)
	// 			{
	// 				case 1, 2, 3: //enable and target dad
	// 					if(val == 1) //enable
	// 					{
	// 						dadbattleBlack.visible = true;
	// 						dadbattleLight.visible = true;
	// 						dadbattleFog.visible = true;
	// 						defaultCamZoom += 0.12;
	// 					}

	// 					var who:Character = dad;
	// 					if(val > 2) who = boyfriend;
	// 					//2 only targets dad
	// 					dadbattleLight.alpha = 0;
	// 					new FlxTimer().start(0.12, function(tmr:FlxTimer) {
	// 						dadbattleLight.alpha = 0.375;
	// 					});
	// 					dadbattleLight.setPosition(who.getGraphicMidpoint().x - dadbattleLight.width / 2, who.y + who.height - dadbattleLight.height + 50);
	// 					FlxTween.tween(dadbattleFog, {alpha: 0.7}, 1.5, {ease: FlxEase.quadInOut});

	// 				default:
	// 					dadbattleBlack.visible = false;
	// 					dadbattleLight.visible = false;
	// 					defaultCamZoom -= 0.12;
	// 					FlxTween.tween(dadbattleFog, {alpha: 0}, 0.7, {onComplete: function(twn:FlxTween) dadbattleFog.visible = false});
	// 			}
	// 	}
	// }
}