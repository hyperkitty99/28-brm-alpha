package options;

class VisualsUISubState extends BaseOptionsMenu {
	public function new() {
		title = getLocalizedString("visualsandui");
		rpcTitle = getLocalizedString("visualsanduiRPC"); //for Discord Rich Presence

		var option:Option = new Option(getLocalizedString("time_bar"), getLocalizedString("time_bar_des"), 'timeBarType', 'string', ['Time Left', 'Time Elapsed', 'Song Name', 'Disabled']);
		addOption(option);

		var option:Option = new Option(getLocalizedString("hide_hud"), getLocalizedString("hide_hud_des"), 'hideHud', 'bool');
		addOption(option);

		var option:Option = new Option(getLocalizedString("flashing_lights"), getLocalizedString("flashing_lights_des"), 'flashing', 'bool');
		addOption(option);

		var option:Option = new Option(getLocalizedString("fps_counter"), getLocalizedString("fps_counter_des"), 'showFPS', 'bool');
		addOption(option);
		option.onChange = onChangeFPSCounter;

		var option:Option = new Option(getLocalizedString("language"), getLocalizedString("language_des"), 'language', 'string', ['Russian', 'English']);
		addOption(option);
		option.onChange = onChangeLanguage;

		super();
	}

	function onChangeFPSCounter() if(Main.fpsVar != null) Main.fpsVar.visible = ClientPrefs.data.showFPS;
	function onChangeLanguage() loadLocalizedLanguage(ClientPrefs.data.language);
}
