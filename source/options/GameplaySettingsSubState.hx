package options;

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Gameplay Settings';
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Downscroll', //Name
		getLocalizedString("downscroll_des"),
		'downScroll', //Save data variable name
		'bool'); //Variable type
	    addOption(option);

	    var option:Option = new Option('Middlescroll',
		getLocalizedString("middlescroll_des"),
		'middleScroll',
		'bool');
	    addOption(option);

	    var option:Option = new Option(getLocalizedString("disable_reset_button"),
		getLocalizedString("disable_reset_button_des"),
		'noReset',
		'bool');
	    addOption(option);

		var option:Option = new Option('Safe Frames',
			'Changes how many frames you have for\nhitting a note earlier or late.',
			'safeFrames',
			'float');
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);

		super();
	}
}